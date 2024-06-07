use clap::Parser;

#[derive(Parser, Debug)]
struct Args {
    /// Name of the person to greet
    #[arg(short, long)]
    name: String,
}

fn main() {
    let args = Args::parse();

    println!("Hello {}!", args.name)
}
