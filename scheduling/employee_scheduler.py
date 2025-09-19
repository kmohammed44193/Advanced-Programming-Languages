# Employee Scheduler  
import random
random.seed(42)

DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
SHIFTS = ["Morning", "Afternoon", "Evening"]

SHIFT_MIN_STAFF = 2          # Requirement: at least 2 employees per shift
SHIFT_CAPACITY  = 2          # Soft capacity per shift (set to 2 if you prefer)
MAX_DAYS_PER_EMP = 5         # At most 5 days per employee per week

# ---------- Sample data ----------
# Preferences are ranked lists (1st → last) and reused for each day
EMPLOYEE_PREFERENCES = {
    "Ava":    ["Morning", "Afternoon", "Evening"],
    "Ben":    ["Afternoon", "Evening", "Morning"],
    "Cara":   ["Evening", "Morning", "Afternoon"],
    "Diego":  ["Morning", "Evening", "Afternoon"],
    "Eli":    ["Afternoon", "Morning", "Evening"],
    "Farah":  ["Evening", "Afternoon", "Morning"],
    "Grace":  ["Morning", "Afternoon", "Evening"],
    "Hassan": ["Afternoon", "Evening", "Morning"],
    "Ivy":    ["Morning", "Evening", "Afternoon"],
    "Jon":    ["Evening", "Morning", "Afternoon"],
}

# ---------- Helpers ----------
def empty_schedule():
    return {day: {shift: [] for shift in SHIFTS} for day in DAYS}

def employee_stats(names):
    return {name: {"days": 0, "assigned_days": set()} for name in names}

def can_work(emp, day, stats):
    return (stats[emp]["days"] < MAX_DAYS_PER_EMP) and (day not in stats[emp]["assigned_days"])

def assign(emp, day, shift, schedule, stats):
    schedule[day][shift].append(emp)
    stats[emp]["days"] += 1
    stats[emp]["assigned_days"].add(day)

def has_capacity(day, shift, schedule):
    return len(schedule[day][shift]) < SHIFT_CAPACITY

def any_capacity(day, schedule):
    return any(len(schedule[day][s]) < SHIFT_CAPACITY for s in SHIFTS)

# ---------- Build schedule ----------
def build_schedule():
    schedule = empty_schedule()
    employees = list(EMPLOYEE_PREFERENCES.keys())
    stats = employee_stats(employees)

    carry_over = []  # employees bumped to “next day” when everything is full

    for day in DAYS:
        # 1) Start with carry-over employees from previous day (if any)
        pool = carry_over + employees
        carry_over = []
        random.shuffle(pool)

        # 2) First pass: try to honor ranked preferences with capacity limits
        for emp in pool:
            if not can_work(emp, day, stats):
                continue
            placed = False
            for pref in EMPLOYEE_PREFERENCES[emp]:
                if has_capacity(day, pref, schedule):
                    assign(emp, day, pref, schedule, stats)
                    placed = True
                    break
            if not placed:
                # Try any other shift with capacity (same day)
                for alt in SHIFTS:
                    if has_capacity(day, alt, schedule):
                        assign(emp, day, alt, schedule, stats)
                        placed = True
                        break
            if not placed:
                # Everything full today → try next day (conflict resolution)
                carry_over.append(emp)

        # 3) Enforce minimum staffing with FAIRNESS (fewest days worked first)
        for shift in SHIFTS:
            needed = max(0, SHIFT_MIN_STAFF - len(schedule[day][shift]))
            if needed == 0:
                continue
            eligible = [
                e for e in employees
                if can_work(e, day, stats) and (day not in stats[e]["assigned_days"])
            ]
            # choose those with the fewest days to spread work across the week
            eligible.sort(key=lambda e: stats[e]["days"])
            for _ in range(needed):
                if not eligible:
                    break
                pick = eligible.pop(0)
                assign(pick, day, shift, schedule, stats)
                # keep list fair as days increase
                eligible.sort(key=lambda e: stats[e]["days"])

        # 4) Optional fair fill to use leftover capacity (still fewest-days first)
        unassigned = [e for e in employees if can_work(e, day, stats)]
        unassigned.sort(key=lambda e: stats[e]["days"])
        for emp in unassigned:
            placed = False
            for pref in EMPLOYEE_PREFERENCES[emp]:
                if has_capacity(day, pref, schedule):
                    assign(emp, day, pref, schedule, stats)
                    placed = True
                    break
            if not placed and not any_capacity(day, schedule):
                carry_over.append(emp)

    return schedule, stats

# ---------- Pretty printing ----------
def print_schedule(schedule, stats):
    print("\n=== FINAL WEEKLY SCHEDULE ===")
    header = f"{'Day':<5} | " + " | ".join(f"{s:<25}" for s in SHIFTS)
    print(header)
    print("-" * len(header))
    for day in DAYS:
        row = [", ".join(schedule[day][s]) if schedule[day][s] else "-" for s in SHIFTS]
        print(f"{day:<5} | " + " | ".join(f"{cell:<25}" for cell in row))

    print("\n=== EMPLOYEE SUMMARY (max 5 days) ===")
    for emp in sorted(stats.keys()):
        days_str = ", ".join(sorted(stats[emp]['assigned_days'], key=lambda d: DAYS.index(d)))
        print(f"{emp:<8}: {stats[emp]['days']} day(s) → {days_str}")

    # Sanity checks
    print("\n=== CONSTRAINT CHECKS ===")
    # 1) One shift per day per employee
    ok_one_shift_per_day = True
    for day in DAYS:
        seen = set()
        for shift in SHIFTS:
            for emp in schedule[day][shift]:
                if emp in seen:
                    ok_one_shift_per_day = False
                seen.add(emp)
    print("One shift per employee per day:", "OK" if ok_one_shift_per_day else "VIOLATION")

    # 2) Weekly cap
    ok_week_cap = all(v["days"] <= MAX_DAYS_PER_EMP for v in stats.values())
    print("Max 5 days per employee:", "OK" if ok_week_cap else "VIOLATION")

    # 3) Minimum staffing
    min_ok = True
    for day in DAYS:
        for shift in SHIFTS:
            if len(schedule[day][shift]) < SHIFT_MIN_STAFF:
                min_ok = False
    print("Minimum 2 employees per shift:", "OK" if min_ok else "COULD NOT FILL (insufficient eligible staff)")

# ---------- Run ----------
if __name__ == "__main__":
    schedule, stats = build_schedule()
    print_schedule(schedule, stats)
