fn allocate(n: usize) -> Vec<u8> {
    vec![42; n]
}

fn mutate(v: &mut Vec<u8>) {
    for x in v.iter_mut().take(5) {
        *x += 1;
    }
}

fn main() {
    let mut data = allocate(1_000_000);
    mutate(&mut data);
    println!("first five = {:?}", &data[..5]);
    drop(data); // freed automatically at end of scope
}
