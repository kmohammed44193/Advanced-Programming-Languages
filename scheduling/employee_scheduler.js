// Employee Scheduler 
// Deterministic RNG (mulberry32)
function mulberry32(a) {
  return function() {
    var t = a += 0x6D2B79F5;
    t = Math.imul(t ^ t >>> 15, t | 1);
    t ^= t + Math.imul(t ^ t >>> 7, t | 61);
    return ((t ^ t >>> 14) >>> 0) / 4294967296;
  }
}
const rand = mulberry32(42);
function shuffle(arr){ for(let i=arr.length-1;i>0;i--){ const j=Math.floor(rand()*(i+1)); [arr[i],arr[j]]=[arr[j],arr[i]]; } }

const DAYS = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
const SHIFTS = ["Morning","Afternoon","Evening"];
const SHIFT_MIN_STAFF = 2;
const SHIFT_CAPACITY = 2; // set to 2 if you want the simplest guaranteed pass
const MAX_DAYS_PER_EMP = 5;

const EMPLOYEE_PREFERENCES = {
  "Ava":   ["Morning","Afternoon","Evening"],
  "Ben":   ["Afternoon","Evening","Morning"],
  "Cara":  ["Evening","Morning","Afternoon"],
  "Diego": ["Morning","Evening","Afternoon"],
  "Eli":   ["Afternoon","Morning","Evening"],
  "Farah": ["Evening","Afternoon","Morning"],
  "Grace": ["Morning","Afternoon","Evening"],
  "Hassan":["Afternoon","Evening","Morning"],
  "Ivy":   ["Morning","Evening","Afternoon"],
  "Jon":   ["Evening","Morning","Afternoon"],
};

function emptySchedule(){
  const sch = {};
  for(const d of DAYS){
    sch[d] = {};
    for(const s of SHIFTS) sch[d][s] = [];
  }
  return sch;
}
function employeeStats(names){
  const st = {};
  for(const n of names) st[n] = {days:0, assigned:new Set()};
  return st;
}
function canWork(emp, day, stats){
  return stats[emp].days < MAX_DAYS_PER_EMP && !stats[emp].assigned.has(day);
}
function assign(emp, day, shift, schedule, stats){
  schedule[day][shift].push(emp);
  stats[emp].days += 1;
  stats[emp].assigned.add(day);
}
function hasCapacity(day, shift, schedule){
  return schedule[day][shift].length < SHIFT_CAPACITY;
}
function anyCapacity(day, schedule){
  return SHIFTS.some(s => schedule[day][s].length < SHIFT_CAPACITY);
}

function buildSchedule(){
  const schedule = emptySchedule();
  const employees = Object.keys(EMPLOYEE_PREFERENCES);
  const stats = employeeStats(employees);
  let carryOver = [];

  for(const day of DAYS){
    const pool = carryOver.concat(employees);
    carryOver = [];
    shuffle(pool);

    // First pass: try preferences with capacity
    for(const emp of pool){
      if(!canWork(emp, day, stats)) continue;
      let placed = false;
      for(const pref of EMPLOYEE_PREFERENCES[emp]){
        if(hasCapacity(day, pref, schedule)){
          assign(emp, day, pref, schedule, stats);
          placed = true; break;
        }
      }
      if(!placed){
        for(const alt of SHIFTS){
          if(hasCapacity(day, alt, schedule)){
            assign(emp, day, alt, schedule, stats);
            placed = true; break;
          }
        }
      }
      if(!placed) carryOver.push(emp);
    }

    // Minimum staffing with fairness (fewest days first)
    for(const shift of SHIFTS){
      let need = Math.max(0, SHIFT_MIN_STAFF - schedule[day][shift].length);
      if(need === 0) continue;
      let eligible = employees.filter(e => canWork(e, day, stats));
      eligible.sort((a,b) => stats[a].days - stats[b].days);
      while(need-- > 0 && eligible.length){
        const pick = eligible.shift();
        assign(pick, day, shift, schedule, stats);
        // keep list sorted as days change
        eligible.sort((a,b) => stats[a].days - stats[b].days);
      }
    }

    // Optional second pass to fill remaining capacity by fairness
    let unassigned = employees.filter(e => canWork(e, day, stats));
    unassigned.sort((a,b) => stats[a].days - stats[b].days);
    for(const emp of unassigned){
      let placed = false;
      for(const pref of EMPLOYEE_PREFERENCES[emp]){
        if(hasCapacity(day, pref, schedule)){
          assign(emp, day, pref, schedule, stats);
          placed = true; break;
        }
      }
      if(!placed && !anyCapacity(day, schedule)) carryOver.push(emp);
    }
  }
  return {schedule, stats};
}

function printSchedule(schedule, stats){
  console.log("\n=== FINAL WEEKLY SCHEDULE ===");
  const header = `Day  | ${SHIFTS.map(s => s.padEnd(25)).join(" | ")}`;
  console.log(header);
  console.log("-".repeat(header.length));
  for(const day of DAYS){
    const row = SHIFTS.map(s => {
      const v = schedule[day][s];
      return (v.length ? v.join(", ") : "-").padEnd(25);
    }).join(" | ");
    console.log(`${day.padEnd(4)} | ${row}`);
  }

  console.log("\n=== EMPLOYEE SUMMARY (max 5 days) ===");
  const names = Object.keys(stats).sort();
  for(const n of names){
    const days = stats[n].days;
    const ds = Array.from(stats[n].assigned);
    ds.sort((a,b) => DAYS.indexOf(a) - DAYS.indexOf(b));
    console.log(`${n.padEnd(8)}: ${days} day(s) \u2192 ${ds.join(", ")}`);
  }

  // Checks
  console.log("\n=== CONSTRAINT CHECKS ===");
  // One shift per day
  let okOne = true;
  for(const day of DAYS){
    const seen = new Set();
    for(const s of SHIFTS){
      for(const e of schedule[day][s]){
        if(seen.has(e)) okOne = false;
        seen.add(e);
      }
    }
  }
  console.log("One shift per employee per day:", okOne ? "OK" : "VIOLATION");

  // Max 5 per week
  const okMax = Object.values(stats).every(v => v.days <= MAX_DAYS_PER_EMP);
  console.log("Max 5 days per employee:", okMax ? "OK" : "VIOLATION");

  // Minimum 2 per shift
  let minOk = true;
  for(const d of DAYS){
    for(const s of SHIFTS){
      if(schedule[d][s].length < SHIFT_MIN_STAFF) minOk = false;
    }
  }
  console.log("Minimum 2 employees per shift:", minOk ? "OK" : "COULD NOT FILL");
}

// Run
const {schedule, stats} = buildSchedule();
printSchedule(schedule, stats);
