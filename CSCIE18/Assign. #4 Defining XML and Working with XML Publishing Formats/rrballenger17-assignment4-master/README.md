# Designing and Defining XML
## assignment4-part1

For this part of the assignment, you will design a weather XML format to make improvements on the structure of the data contained in the “NWS Weather XML”.  We discussed earlier in the term (October 13) several possibilities for improvements and the rationale for them.  You will then define your newly created weather XML, provide an example document, and briefly discuss some of the changes you implemented.  Note that this part of the assignment has nothing to do with eXist; the relevant files are:

    .
    └── weather
        ├── KBOS.xml     # original NWS Weather XML
        ├── changes.txt  # describe your 5 improvements
        ├── weather.rnc  # RELAX NG compact syntax for your new XML
    	├── weather.rng  # RELAX NG XML syntax for your new XML
    	├── weather.xml  # Example document for your new XML format
    	└── weather.xsd  # W3C XML schema for your new XML

* Design a new XML format that will contain weather data.  You can think of this as an exercise to improve the XML format from the NWS Weather XML.
  * An example of this format is in `KBOS.xml`.  
  * Feel free to find weather data from another location that is more interesting to you.  
    Select a state at http://www.weather.gov/xml/current_obs/seek.php and then use the “XML” link for one of the observation locations. 
* **Briefly describe 5 of the changes and why it is an improvement** that you made (changes based on the original NWS Weather XML format).  For each change, one or two sentences should be sufficient to describe the change and the reason for it.  You can also include a “original” and “improved” code example.  Describe these changes in the text file `changes.txt` file.  
* **Create an XML document based on your new format.**  Use data from one of the NWS Weather XML documents and format the data in your new and improved structure.  Your XML file should be in weather.xml.
* **Define your XML format using W3C XML Schema and RELAX NG.**  Create an W3C XML Schema (`weather.xsd`) and RELAX NG schemas (`weather.rng` and `weather.rnc`) to define your weather XML format.  Once you have those schemas written, you should be able to validate your weather.xml using them.
