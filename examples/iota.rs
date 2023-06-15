use std::error::Error;
use std::io;

use rivi_loader::{DebugOption, Vulkan};
use rivi_bqn::*;

fn main() -> io::Result<()> {

    let vk = Vulkan::new(DebugOption::None).unwrap();
    println!("{}", vk);

    let lines = io::stdin().lines();

    for line in lines {
      println!("{:?}", line.unwrap());
    };

    //gpu_run();

    Ok(())
}
