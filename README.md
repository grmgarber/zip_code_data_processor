# zip_code_data_processor
Demo ruby code to produce some statistics based on US zip code JSON data 

The code for the whole challenge is contained in the signle class: Challenge1.

Following are the command line options to invoke the functionality really quickly:
 If your data is in the default zips.json file located in the current directory, run this
   ruby -r './challenge1.rb' -e 'puts Challenge1.perform.to_s'

 If your JSON input file is located elsewhere, you can specify its file spec.  E.g, running from the parent directory:
#   ruby -r './gg_challenge1/challenge1.rb' -e "puts Challenge1.perform('./gg_challenge1/zips.json').to_s"

 If your data is coming from another source, then firstly convert it to the array of zip code infos <myarr>.
 Then you can still use the Challenge1 class like this, e.g. with interactive ruby interpreter irb: 
  
1) start interactive ruby irb, and then:
2) irb> load '/path/to/this/file/challenge1.rb'
3) irb> c = Challenge1.new
4) irb> c.source = myarr
5) irb> c.process_source_data  
