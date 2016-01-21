/** {@code WordCountByFile} is a utitity to count the number of times words occur in each input file. 
 *  It puts together the results to show how many times a particular word occurred in each. The map method
 *  of the MapReduce program tallies each time a word occurs in a file. The reduce part then counts
 *  the number of occurences by file name and outputs the number of times the word occurs in each file. 
 *  @author Ryan Ballenger
 *  @version 1.0
 *  @since December 16, 2015
 */
package cscie55.hw7;

import java.io.IOException;
import java.util.*;
import java.util.HashMap;

import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.*;
import org.apache.hadoop.mapreduce.lib.output.*;
import org.apache.hadoop.util.*;

public class WordCountByFile extends Configured implements Tool {

    public static void main(String args[]) throws Exception {
	int res = ToolRunner.run(new WordCountByFile(), args);
	System.exit(res);
    }

    public int run(String[] args) throws Exception {
	Path inputPath = new Path(args[0]);
	Path outputPath = new Path(args[1]);

	Configuration conf = getConf();
	Job job = new Job(conf, this.getClass().toString());

	FileInputFormat.setInputPaths(job, inputPath);
	FileOutputFormat.setOutputPath(job, outputPath);

	job.setJobName("WordCountByFile");
	job.setJarByClass(WordCountByFile.class);
	job.setInputFormatClass(TextInputFormat.class);
	job.setOutputFormatClass(TextOutputFormat.class);
	// adjusted
	job.setMapOutputKeyClass(Text.class);
	job.setMapOutputValueClass(Text.class);
	// adjusted
	job.setOutputKeyClass(Text.class);
	job.setOutputValueClass(Text.class);

	job.setMapperClass(Map.class);
	//job.setCombinerClass(Reduce.class);
	job.setReducerClass(Reduce.class);

	return job.waitForCompletion(true) ? 0 : 1;
    }

    //adjusted 
    public static class Map extends Mapper<LongWritable, Text, Text, Text> {
		private final static IntWritable one = new IntWritable(1);
		private Text word = new Text();

		/**   
 	      *  The map method tokenizes the line and writes each occurring word and the filename
 	      *  to the context to be tallied by the reduce method.
 	      * 
 	 	  *  @param key MapReduce key, unused in this case
 	 	  *  @param value line read from a file
 	 	  *  @param context MapReduce context where the output is written from the map method
 	 	  */
    	@Override
		public void map(LongWritable key, Text value, Mapper.Context context) throws IOException, InterruptedException {
			String line = value.toString();
			StringTokenizer tokenizer = new StringTokenizer(line);

			// get file path and name
			String fileName = ((FileSplit) context.getInputSplit()).getPath().toString();

	    	
			while (tokenizer.hasMoreTokens()) {
	    		word.set(tokenizer.nextToken());
	    		
	    		String theWord = word.toString();
	    		
	    		context.write(new Text(theWord), new Text(fileName));
			}

    	}
    }

    //adjusted
    public static class Reduce extends Reducer<Text, Text, Text, Text> {


    /**   
 	  *  The reduce method counts the number of times each file occurs by storing them 
 	  *  and the count in a hashmap. It adds the file names and the count to an array list
 	  *  to be sorted. Lastly it concatenates a string with all the filenames and counts to 
 	  *  write to the output context.
 	  * 
 	  *  @param key word that is being counted
 	  *  @param value filename in an iterable for each occurence
 	  *  @param context MapReduce context where the output is written from the reduce method
 	  */
    @Override
    // adjusted
	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {

		// count the number of times each file name occurs
		HashMap<String, Integer> storage = new HashMap<String, Integer>();
		for (Text value : values) {
			String v = value.toString();

	    	if(storage.containsKey(v)){
	    		storage.put(v, 1 + ((Integer)storage.get(v)));
	    	}else{
	    		storage.put(v, 1);
	    	}

		}
		
		// put file names and counts into an array list to be sorted
		ArrayList<String> list = new ArrayList<String>();
		for (HashMap.Entry<String, Integer> entry : storage.entrySet()) {
    		String sum = entry.getKey() + ": " + entry.getValue();
    		list.add(sum);
		}
		Collections.sort(list);

		// combine all file names and counts for the output string
		String output = "";
		for(String s: list){
			output += " " + s;
		}

		context.write(key, new Text(output));

    }
    }

}





