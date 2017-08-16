package rcaller.matrix;

import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.AfterClass;
import rcaller.Globals;

public class RealMatrixTest {

    double[][] matrix = new double[][]{{1.0, 2.0}, {4.0, 9.0}};
    double[][] inverse = new double[][]{{9.0, -2.0}, {-4.0, 1.0}};
    double[][] another = new double[][]{{8, 7}, {11, -1}};
    String pathToR;
    double delta = 0.00001;
    static RealMatrix rm = null;

    @AfterClass
    public static void MyAfterClass() {
        System.out.println("***** Finalizing RealMatrixTest *****");
        rm.rcaller.deleteTempFiles();
    }

    public RealMatrixTest() {
        Globals.detect_current_rscript();
        pathToR = Globals.R_current;
        if (rm == null) {
            rm = new RealMatrix(pathToR, "MyMatrix");
        }
        rm.setData(matrix);
    }

    @Test
    public void testGetDimensions() {
        System.out.print("getDimensions: ");
        int[] dims = rm.getDimensions();
        assertEquals(dims[0], matrix.length);
        assertEquals(dims[1], matrix[0].length);
    }

    @Test
    public void testSetGetData() {
        System.out.println("setData and GetData: ");
        double[][] nm = rm.getData();
        assertEquals(nm[0][0], matrix[0][0], delta);
        assertEquals(nm[0][1], matrix[0][1], delta);
        assertEquals(nm[1][0], matrix[1][0], delta);
        assertEquals(nm[1][1], matrix[1][1], delta);
    }

    @Test
    public void testGetDeterminant() {
        System.out.println("getDeterminant");
        double det = rm.getDeterminant();
        assertTrue(det == 1.0);
    }

    @Test
    public void testGetInverse() {
        System.out.println("getInverse");
        double[][] myinverse = rm.getInverse().getData();
        assertEquals(inverse[0][0], myinverse[0][0], delta);
        assertEquals(inverse[1][0], myinverse[1][0], delta);
        assertEquals(inverse[0][1], myinverse[0][1], delta);
        assertEquals(inverse[1][1], myinverse[1][1], delta);
    }

    @Test
    public void testGetDiagonal() {
        System.out.println("getDiagonal");
        double[] diagonal = rm.getDiagonal();
        assertEquals(matrix[0][0], diagonal[0], delta);
        assertEquals(matrix[1][1], diagonal[1], delta);
    }

    @Test
    public void testGetTrace() {
        System.out.println("getTrace");
        double trace = rm.getTrace();
        assertEquals(10.0, trace, delta);
    }

    @Test
    public void testGetTranspose() {
        System.out.println("getTranspose");
        double[][] t = rm.getTranspose().getData();
        assertEquals(matrix[0][0], t[0][0], delta);
        assertEquals(matrix[0][1], t[1][0], delta);
        assertEquals(matrix[1][0], t[0][1], delta);
        assertEquals(matrix[1][1], t[1][1], delta);
    }

    @Test
    public void testProductMatrix() {
        System.out.println("product");
        double[][] result = rm.product(another).getData();
        assertEquals(30.0, result[0][0], delta);
        assertEquals(5.0, result[1][0], delta);
        assertEquals(131.0, result[0][1], delta);
        assertEquals(19.0, result[1][1], delta);

        System.out.println("product2");
        RealMatrix resultMat = rm.product(another);
        result = resultMat.getData();
        assertEquals(30.0, result[0][0], delta);
        assertEquals(5.0, result[1][0], delta);
        assertEquals(131.0, result[0][1], delta);
        assertEquals(19.0, result[1][1], delta);
    }

    @Test
    public void testSumMatrix() {
        System.out.println("sum");
        double[][] result = rm.sum(another).getData();
        assertEquals(9.0, result[0][0], delta);
        assertEquals(9.0, result[1][0], delta);
        assertEquals(15.0, result[0][1], delta);
        assertEquals(8.0, result[1][1], delta);
    }

    @Test
    public void testProductWithScaler() {
        System.out.println("Matrix product with scaler");
        double scaler = 10.0;
        double[][] result = rm.productWithScaler(scaler).getData();
        assertEquals(matrix[0][0] * scaler, result[0][0], delta);
        assertEquals(matrix[0][1] * scaler, result[1][0], delta);
        assertEquals(matrix[1][0] * scaler, result[0][1], delta);
        assertEquals(matrix[1][1] * scaler, result[1][1], delta);
    }

    @Test
    public void testSubtractMatrix() {
        System.out.println("subtract");
        double[][] result = rm.subtract(another).getData();
        assertEquals(-7.0, result[0][0], delta);
        assertEquals(-5.0, result[1][0], delta);
        assertEquals(-7.0, result[0][1], delta);
        assertEquals(10.0, result[1][1], delta);
    }

    @Test
    public void testEigenValues() {
        System.out.println("eigen-values");
        double[] result = rm.getEigenValues();
        assertEquals(9.8989795, result[0], delta);
        assertEquals(0.1010205, result[1], delta);
    }

    @Test
    public void testEigenVectors() {
        System.out.println("eigen-vectors");
        double[][] result = rm.getEigenVectors().getData();
        assertEquals(-0.2192753, result[0][0], delta);
        assertEquals(-0.9120956, result[0][1], delta);
        assertEquals(-0.9756630, result[1][0], delta);
        assertEquals(0.4099776, result[1][1], delta);
    }

    @Test
    public void testGetColumn() {
        System.out.println("getColumn");
        double[] result = rm.getColumn(1);
        assertEquals(1.0, result[0], delta);
        assertEquals(4.0, result[1], delta);
    }

    @Test
    public void testRow() {
        System.out.println("getRow");
        double[] result = rm.getRow(1);
        assertEquals(1.0, result[0], delta);
        assertEquals(2.0, result[1], delta);
    }

    @Test
    public void testGetColumns() {
        System.out.println("getColumns");
        double[][] result = rm.getColumns(new int[]{1, 2});
        assertEquals(1.0, result[0][0], delta);
        assertEquals(2.0, result[0][1], delta);
        assertEquals(4.0, result[1][0], delta);
        assertEquals(9.0, result[1][1], delta);
    }

    @Test
    public void testGetRows() {
        System.out.println("getRows");
        double[][] result = rm.getRows(new int[]{1, 2});
        assertEquals(1.0, result[0][0], delta);
        assertEquals(2.0, result[0][1], delta);
        assertEquals(4.0, result[1][0], delta);
        assertEquals(9.0, result[1][1], delta);
    }

    @Test
    public void testSVD() {
        System.out.println("SVD");
        SVD svd = rm.getSVD();
        double[][] uMatrix = svd.u.getData();
        double[][] vMatrix = svd.v.getData();

        assertEquals(10.09901951, svd.d[0], delta);
        assertEquals(0.09901951, svd.d[1], delta);

        assertEquals(-0.2212078, uMatrix[0][0], delta);
        assertEquals(-0.9752267, uMatrix[0][1], delta);
        assertEquals(-0.9752267, uMatrix[1][0], delta);
        assertEquals(0.2212078, uMatrix[1][1], delta);

        assertEquals(-0.4081698, vMatrix[0][0], delta);
        assertEquals(-0.9129060, vMatrix[0][1], delta);
        assertEquals(-0.9129060, vMatrix[1][0], delta);
        assertEquals(0.4081698, vMatrix[1][1], delta);
    }

}
