class FileWriter extends Thread {

  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  String id;                 // Thread name

  PrintWriter output;

  // Constructor, create the thread
  // It is not running by default
  FileWriter (int w, String s) {
    wait = w;
    running = false;
    id = s;

    //prepare date filename
    int min = minute();
    int h = hour();
    int d = day();    // Values from 1 - 31
    int m = month();  // Values from 1 - 12
    int y = year();   // 2003, 2004, 2005, etc.
    output = createWriter("data/"+String.valueOf(y) + "-"+String.valueOf(m) +"-"+String.valueOf(d) +"-"+String.valueOf(h) +"-"+String.valueOf(min)+"-log.txt");
  }


  void start () {
    // Set running equal to true
    running = true;
    // Print messages
    println("Starting thread (will execute every " + wait + " milliseconds.)"); 
    // Do whatever start does in Thread, don't forget this!
    super.start();
  }


  // We must implement run, this gets triggered by start()
  void run () {
    while (running) {

      Date d = new Date();
      long currentTime = d.getTime(); 

      String tmpString = String.valueOf(currentTime) + ",";


      tmpString = tmpString + serialVal;

      output.println(tmpString);
      output.flush();

      // Ok, let's wait for however long we should wait
      try {
        sleep((long)(wait));
      } 
      catch (Exception e) {
      }
    }
    System.out.println(id + " thread is done!");  // The thread is done when we get to the end of run()
  }


  // Our method that quits the thread
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()

    //close file writing
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file

      // IUn case the thread is waiting. . .
    interrupt();
  }

  boolean isRunning() {
    return this.running;
  }
}

