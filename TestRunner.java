import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

class TestRunner {
    public static void main(String args[]) throws Exception {
        File folder = new File("test");
        File[] listOfFiles = folder.listFiles();

        for (int i = 0; i < listOfFiles.length; i++) {
            if (listOfFiles[i].isFile()) {
                System.out.println(">> Running: ./uc test/" + listOfFiles[i].getName());

                try {
                    Process process;
                    process = Runtime.getRuntime().exec(
                        "./build/uc test/"+listOfFiles[i].getName(), null, new File(System.getProperty("user.dir")));
            
                    StringBuilder output = new StringBuilder();
            
                    BufferedReader reader = new BufferedReader(
                            new InputStreamReader(process.getInputStream()));
            
                    String line;
                    while ((line = reader.readLine()) != null) {
                        output.append(line + "\n");
                    }
            
                    int exitVal = process.waitFor();
                    if (exitVal == 0) {
                        System.out.println("<< Success!");
                        System.out.println(output);
                        // System.exit(0);
                    } else {
                        //abnormal...
                    }
            
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}