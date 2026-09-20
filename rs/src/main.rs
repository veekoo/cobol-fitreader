use std::{env, fs, process};

fn main() {
    let path = match env::args().nth(1) {
        Some(path) => path,
        None => {
            eprintln!("usage: fit-reader <file.fit>");
            process::exit(1);
        }
    };

    let bytes = match fs::read(&path) {
        Ok(bytes) => bytes,
        Err(err) => {
            eprintln!("failed to read '{}': {}", path, err);
            process::exit(1);
        }
    };

    let fit = match fitparser::FitData::new(&bytes) {
        Ok(fit) => fit,
        Err(err) => {
            eprintln!("failed to parse FIT file '{}': {}", path, err);
            process::exit(1);
        }
    };

    match fit.messages() {
        Ok(messages) => {
            for message in messages {
                println!("Message: {}", message.name());
                for field in message.fields() {
                    println!("  {} = {:?}", field.name(), field.value());
                }
                println!();
            }
        }
        Err(err) => {
            eprintln!("failed to decode messages from '{}': {}", path, err);
            process::exit(1);
        }
    }
}
