/** {@code DocWordIndex} is a utitity to determine what positions a word occurs in all the input files. 
 *  It analyzes the lines from the input file, tracks positions where the words occurs, and finally 
 *  outputs the information. It processes into lines with all the positions in the files together for 
 *  each word. It uses MapReduce where the map method calculates the positions and reduce method
 *  sums all the data together for the output. 
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

public class DocWordIndex extends Configured implements Tool {

    public static void main(String args[]) throws Exception {
	int res = ToolRunner.run(new DocWordIndex(), args);
	System.exit(res);
    }

    public int run(String[] args) throws Exception {
	Path inputPath = new Path(args[0]);
	Path outputPath = new Path(args[1]);

	Configuration conf = getConf();
	Job job = new Job(conf, this.getClass().toString());

	FileInputFormat.setInputPaths(job, inputPath);
	FileOutputFormat.setOutputPath(job, outputPath);

	job.setJobName("DocWordIndex");
	job.setJarByClass(DocWordIndex.class);
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
 	      *  The map method tallies where each word ocurs in a string and keeps the information 
 	      *  in a hashmap with the occurring word as the key. It then writes to the context the word as
 	      *  the key and the filename and positions string as the value.
 	      * 
 	 	  *  @param key MapReduce key, unused in this case
 	 	  *  @param value line read from a file
 	 	  *  @param context MapReduce context where the output is written from the map method
 	 	  */
    	@Override
		public void map(LongWritable key, Text value, Mapper.Context context) throws IOException, InterruptedException {
			String line = value.toString();
			StringTokenizer tokenizer = new StringTokenizer(line);
			String fileName = ((FileSplit) context.getInputSplit()).getPath().toString();

			// word and positions string (i.e. 2 5 9)
	    	HashMap<String, String> storage = new HashMap<String, String>();
			
			// create string of positions where the key occurs
			int count = 0;
			while (tokenizer.hasMoreTokens()) {
				count++;
	    		word.set(tokenizer.nextToken());
	    		String theWord = word.toString();
	    		
	    		if(storage.containsKey(theWord)){
	    			String spots = storage.get(theWord);
	    			storage.put(theWord, spots += " " + count);
	    		}else{
	    			storage.put(theWord, "" + count);
	    		}
			}

			// output word and filename+positions
			for (HashMap.Entry<String, String> entry : storage.entrySet()) {
    			context.write(new Text(entry.getKey()), new Text(fileName + ": " + entry.getValue()));
			}
    	}
    }

    //adjusted
    public static class Reduce extends Reducer<Text, Text, Text, Text> {

    /**   
 	  *  The reduce method sorts the file names for the key word and concatenates the 
 	  *  filename and position strings. It writes to the output the word as the key and the
 	  *  filename and position string as the value.
 	  * 
 	  *  @param key word that is being counted
 	  *  @param value filename in an iterable for each occurence
 	  *  @param context MapReduce context where the output is written from the reduce method
 	  */
    @Override
    // adjusted
	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
		String sum = "";
		ArrayList<String> sortable = new ArrayList<String>();

		// sort file names for concatenated value string
		for (Text value : values) {
			sortable.add(value.toString());
		}
		Collections.sort(sortable);

		// combine filenames and positions
		for(String s: sortable){
			sum += (s + " ");
		}

		// write key word and the sume of filename+position strings
		context.write(key, new Text(sum));

    }
    }

}





