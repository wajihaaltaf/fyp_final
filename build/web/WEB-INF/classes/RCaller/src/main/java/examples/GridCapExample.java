

package examples;

import rcaller.RCaller;
import rcaller.RCode;


public class GridCapExample {
    
    public static void Main(){
        RCaller caller = new RCaller();
        RCode code = new RCode();
        caller.setRscriptExecutable("C:\\Program Files\\R\\R-3.0.2\\bin\\Rscript.exe");
        code.R_require("grid");
        code.addRCode("dev.new(width=.5, height=.5)");
        code.addRCode("grid.rect()");
        code.addRCode("grid.text(\"hi\")");
        code.addRCode("cap <- grid.cap()");
        code.addRCode("dev.off()");
        caller.setRCode(code);
        caller.runAndReturnResult("cap");
        int[] dims = caller.getParser().getDimensions("cap");
        
        System.out.println("Returned matrix dimensions: "+dims[0]+" - "+dims[1]);
    }
}
