package input_feed;

import algebra.curves.barreto_naehrig.bn254a.BN254aFields;
import algebra.curves.barreto_naehrig.bn254a.bn254a_parameters.BN254aFrParameters;
import configuration.Configuration;
import input_feed.distributed.TextToDistributedR1CS;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.storage.StorageLevel;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import relations.objects.Assignment;
import relations.r1cs.R1CSRelationRDD;
import scala.Tuple2;

import java.io.Serializable;

import static org.junit.Assert.assertTrue;


public class distributedFromTextTest implements Serializable {
    private transient JavaSparkContext sc;
    private TextToDistributedR1CS<BN254aFields.BN254aFr> converter;
    private R1CSRelationRDD<BN254aFields.BN254aFr> r1cs;
    private Tuple2<Assignment<BN254aFields.BN254aFr>,
            JavaPairRDD<Long, BN254aFields.BN254aFr>> witness;
    private BN254aFrParameters FpParameters;
    private Configuration config;

    @Before
    public void setUp() {
        sc = new JavaSparkContext("local", "ZKSparkTestSuite");
        int numExecutors = 1;
        int numCores = 1;
        int numMemory = 1;
        int numPartitions = 2;

        config = new Configuration(
                numExecutors, numCores, numMemory, numPartitions, sc, StorageLevel.MEMORY_ONLY());
        FpParameters = new BN254aFrParameters();
    }

    @After
    public void tearDown() {
        sc.stop();
        sc = null;
    }

    @Test
    public void distributedR1CSFromTextTest() {
        String fileName = "src/test/data/text/contrived/small";
        converter = new TextToDistributedR1CS<>(fileName, config, FpParameters);
        r1cs = converter.loadR1CS();
        assertTrue(r1cs.isValid());

        witness = converter.loadWitness();
        assertTrue(r1cs.isSatisfied(witness._1(), witness._2()));
    }

}
