/** {@code WordHistogram} is a utility to tally words by length within input files. It measures the length of
 *  each word in a file or files and calculates a sum of all the words of each length. It uses map-reduce by
 *  mapping each occurance of words by their length. The reduce phase then calculates the sum of the number of 
 *  times each length occurs. 
 *  @author Ryan Ballenger
 *  @version 1.0
 *  @since December 16, 2015
 */
package cscie55.hw7;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.*;
import org.apache.hadoop.mapreduce.lib.output.*;
import org.apache.hadoop.util.*;

public class WordHistogram extends Configured implements Tool {

    public static void main(String args[]) throws Exception {
	int res = ToolRunner.run(new WordHistogram(), args);
	System.exit(res);
    }

    public int run(String[] args) throws Exception {
	Path inputPath = new Path(args[0]);
	Path outputPath = new Path(args[1]);

	Configuration conf = getConf();
	Job job = new Job(conf, this.getClass().toString());

	FileInputFormat.setInputPaths(job, inputPath);
	FileOutputFormat.setOutputPath(job, outputPath);

	job.setJobName("WordHistogram");
	job.setJarByClass(WordHistogram.class);
	job.setInputFormatClass(TextInputFormat.class);
	job.setOutputFormatClass(TextOutputFormat.class);
	// adjusted
	job.setMapOutputKeyClass(IntWritable.class);
	job.setMapOutputValueClass(IntWritable.class);
	// adjusted
	job.setOutputKeyClass(IntWritable.class);
	job.setOutputValueClass(IntWritable.class);

	job.setMapperClass(Map.class);
	job.setCombinerClass(Reduce.class);
	job.setReducerClass(Reduce.class);

	return job.waitForCompletion(true) ? 0 : 1;
    }

    
    public static class Map extends Mapper<LongWritable, Text, IntWritable, IntWritable> {
	private final static IntWritable one = new IntWritable(1);
	private Text word = new Text();

	/** The map method takes an input line from a file. It tokenizes the line and writes 
	 *  the word length and the value of 1 to the context via IntWritables.   
 	 * 
 	 *  @param key MapReduce key, unused in this case
 	 *  @param value line read from a file
 	 *  @param context MapReduce context where the output is written from the map method
 	 */
    @Override
	public void map(LongWritable key, Text value,
			Mapper.Context context) throws IOException, InterruptedException {
			
			String line = value.toString();
			StringTokenizer tokenizer = new StringTokenizer(line);
			while (tokenizer.hasMoreTokens()) {
	    		word.set(tokenizer.nextToken());
	    		//adjusted
	    		IntWritable l = new IntWritable(word.toString().length());
	    		context.write(l, one);
			}
    }
    }

    
    public static class Reduce extends Reducer<IntWritable, IntWritable, IntWritable, IntWritable> {

    /** The reduce method iterates through the values and sums the number of times the parameter
     *  key lengthed words occur in the input files. It writes to the context the key word length and the total 
     *  number of occurrences as calculated.
 	 * 
 	 *  @param key Length of words being summed
 	 *  @param value An IntWritable value of 1 for each time a key-length word occurs
 	 *  @param context MapReduce context where the output is written from the reduce method
 	 */
    @Override
	public void reduce(IntWritable key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
	int sum = 0;
	for (IntWritable value : values) {
	    sum += value.get();
	}

	context.write(key, new IntWritable(sum));
    }
    }

}


