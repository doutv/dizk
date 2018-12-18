package input_feed;

import algebra.curves.barreto_naehrig.bn254a.bn254a_parameters.BN254aFrParameters;
import algebra.fields.Fp;
import configuration.Configuration;
import input_feed.distributed.TextToDistributedR1CS;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.storage.StorageLevel;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import profiler.profiling.InputFeedProfiling;
import relations.objects.Assignment;
import relations.r1cs.R1CSRelationRDD;
import scala.Tuple2;

import java.io.Serializable;

import static org.junit.Assert.assertTrue;


public class DistributedFromTextTest implements Serializable {
    private transient JavaSparkContext sc;
    private Configuration config;
    private BN254aFrParameters FpParameters;
    private TextToDistributedR1CS<Fp> converter;
    private R1CSRelationRDD<Fp> r1cs;
    private Tuple2<Assignment<Fp>, JavaPairRDD<Long, Fp>> witness;
    private Fp fieldFactory;

    @Before
    public void setUp() {
        sc = new JavaSparkContext("local", "ZKSparkTestSuite");
        int numExecutors = 2;
        int numCores = 2;
        int numMemory = 4;
        int numPartitions = 16;

        config = new Configuration(numExecutors, numCores, numMemory, numPartitions, sc, StorageLevel.MEMORY_ONLY());
        FpParameters = new BN254aFrParameters();
        fieldFactory = new Fp(1, FpParameters);
    }

    @After
    public void tearDown() {
        sc.stop();
        sc = null;
    }

    @Test
    public void distributedR1CSFromTextTest() {
        String fileName = "src/test/data/text/contrived/small";
        converter = new TextToDistributedR1CS<>(fileName, config, fieldFactory);

        r1cs = converter.loadR1CS();
        assertTrue(r1cs.isValid());

        witness = converter.loadWitness();
        assertTrue(r1cs.isSatisfied(witness._1(), witness._2()));
    }

    @Test
    public void distributedR1CSFromTextTest2() {
        String fileName = "src/test/data/text/overflow/overflow";
        converter = new TextToDistributedR1CS<>(fileName, config, fieldFactory);

        r1cs = converter.loadR1CS();
        assertTrue(r1cs.isValid());

        witness = converter.loadWitness();
        assertTrue(r1cs.isSatisfied(witness._1(), witness._2()));
    }

    @Test
    public void mediumDistributedR1CSFromText() {
        String fileName = "src/test/data/text/pephash/hash_transform";
        converter = new TextToDistributedR1CS<>(fileName, config, fieldFactory, true);

        r1cs = converter.loadR1CS();
        assertTrue(r1cs.isValid());

        witness = converter.loadWitness();
        assertTrue(r1cs.isSatisfied(witness._1(), witness._2()));
    }

}
