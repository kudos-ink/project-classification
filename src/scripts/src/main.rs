use std::env;
use std::fs;
use std::process;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: generate_payload <path_to_project_json>");
        process::exit(1);
    }

    let project_json_path = &args[1];

    let project_json =
        fs::read_to_string(project_json_path).expect("Failed to read project JSON file");

    let payload_template = fs::read_to_string("../../src/import/payloads/template.json")
        .expect("Failed to read payload template");

    let full_payload =
        payload_template.replace("\"{body}\"", &serde_json::to_string(&project_json).unwrap());

    let output_path = format!(
        "../../src/import/payloads/{}",
        project_json_path.split('/').last().unwrap()
    );
    println!("This is the output path {}", &output_path);
    fs::write(&output_path, full_payload).expect("Failed to write full payload");

    println!("Payload generated and saved to {}", &output_path);
}
