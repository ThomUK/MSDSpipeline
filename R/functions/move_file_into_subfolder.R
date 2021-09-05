move_file_into_subfolder<- function(filename){
  
  #build the absolute filepath
  current_abs_path <- paste0(getwd(), "/data/downloaded/", filename)
  
  #if the file is actually a directory, return early with no action
  if(file_test("-d", current_abs_path)) return()
  
  #discover which data type the filename is
  type <- discover_data_type(filename)
  
  #the new directory has a subfolder for each type
  new_abs_path <- paste0(dirname(current_abs_path), "/", type, "/", basename(current_abs_path))
  
  #move the file  
  move_file(from = current_abs_path, to = new_abs_path)
}
