(* stats_ocaml.ml — Functional implementation in OCaml *)

module IntMap = Map.Make (Int)

let mean xs =
  let sum = List.fold_left ( + ) 0 xs in
  float_of_int sum /. float_of_int (List.length xs)

let median xs =
  let s = List.sort compare xs in
  let n = List.length s in
  let mid = n / 2 in
  if n mod 2 = 1 then float_of_int (List.nth s mid)
  else float_of_int (List.nth s (mid - 1) + List.nth s mid) /. 2.0

let freq_map xs =
  List.fold_left
    (fun m x ->
       let c = match IntMap.find_opt x m with Some v -> v | None -> 0 in
       IntMap.add x (c + 1) m)
    IntMap.empty xs

let modes xs =
  let m = freq_map xs in
  let maxf = IntMap.fold (fun _ v acc -> max v acc) m 0 in
  let collected =
    IntMap.fold (fun k v acc -> if v = maxf then k :: acc else acc) m []
  in
  List.sort compare collected

let print_stats label data =
  let sorted = List.sort compare data in
  Printf.printf "%s\nInput : [%s]\nSorted: [%s]\nMean  : %.6f\nMedian: %.6f\nMode  : [%s]\n\n"
    label
    (String.concat ", " (List.map string_of_int data))
    (String.concat ", " (List.map string_of_int sorted))
    (mean data)
    (median data)
    (String.concat ", " (List.map string_of_int (modes data)))

let () =
  let demo1 = [1; 2; 2; 3; 4] in
  let demo2 = [5; 1; 9; 3; 7] in
  print_stats "Demo 1" demo1;
  print_stats "Demo 2" demo2
