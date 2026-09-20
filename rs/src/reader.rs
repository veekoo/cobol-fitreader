use fitparser;
use fitparser::de::{DecodeOption, from_reader_with_options};
use std::fs::File;
use std::io::prelude::*;

let fitfilepath = match env::args().nth(1) {
    Some(fitfilepath) => fitfilepath,
    None => {
        eprintln!("usage: fit-reader <file.fit>");
        process::exit(1);
    }
};

println!("Parsing FIT files using Profile version: {:?}", fitparser::profile::VERSION);
let mut fp = File::open(fitfilepath)?;
for data in fitparser::from_reader(&mut fp)? {
    // print the data in FIT file
    println!("{:#?}", data);
}

// Optionally ignore CRC validation
/*
let opts = [DecodeOption::SkipHeaderCrcValidation,
            DecodeOption::SkipDataCrcValidation].iter().map(|o| *o).collect();
let mut fp = File::open(fitfilepath)?;
for data in from_reader_with_options(&mut fp, &opts)? {
    // print the data in FIT file
    println!("{:#?}", data);
}
*/

