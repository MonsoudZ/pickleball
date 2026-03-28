class DemoSeed
  def self.run(backfill_months: 12, forward_months: 3)
    TrainingSession.delete_all
    TrainingProgram.delete_all
    Coach.delete_all

    coach = Coach.create!(
      name: "Monsoud Zanaty",
      certification: "PPR Certified Pro",
      years_experience: 9,
      specialties: "Serve patterns, transition game, pressure drills, doubles strategy",
      bio: "I coach with a structured, competitive approach that helps players build repeatable mechanics and confident decision-making under pressure."
    )

    programs = [
      {
        title: "Foundations Bootcamp",
        level: "Beginner",
        duration_weeks: 4,
        focus_area: "Fundamentals",
        price_cents: 19900,
        description: "Build reliable serves, returns, and court positioning with repeatable cues."
      },
      {
        title: "Kitchen Confidence",
        level: "Intermediate",
        duration_weeks: 6,
        focus_area: "Soft game",
        price_cents: 32900,
        description: "Develop dinking discipline, speed-up recognition, and counter timing at the NVZ."
      },
      {
        title: "Tournament Prep Lab",
        level: "Advanced",
        duration_weeks: 8,
        focus_area: "Competition",
        price_cents: 49900,
        description: "Pressure-tested routines for partner communication, targeting, and match-day execution."
      }
    ].map { |attrs| TrainingProgram.create!(attrs) }

    session_templates = [
      {
        title: "Serve + Return Lab",
        cwday: 2,
        hour: 18,
        minute: 0,
        duration_minutes: 90,
        location: "Private Court",
        skill_level: "Beginner / Intermediate",
        notes: "Use video checkpoints to improve serve depth and return height.",
        spots_total: 10,
        training_program: programs[0]
      },
      {
        title: "Third Shot Drop Intensive",
        cwday: 3,
        hour: 19,
        minute: 0,
        duration_minutes: 90,
        location: "Private Court",
        skill_level: "Intermediate",
        notes: "Pattern progressions from stationary feeds to live transition reps.",
        spots_total: 8,
        training_program: programs[1]
      },
      {
        title: "Transition and Reset Clinic",
        cwday: 4,
        hour: 18,
        minute: 30,
        duration_minutes: 90,
        location: "Private Court",
        skill_level: "Intermediate / Advanced",
        notes: "Mid-court control, reset accuracy, and pressure handling in transition zones.",
        spots_total: 10,
        training_program: programs[1]
      },
      {
        title: "Doubles Decision Clinic",
        cwday: 5,
        hour: 17,
        minute: 30,
        duration_minutes: 120,
        location: "Private Court",
        skill_level: "Intermediate / Advanced",
        notes: "Read-and-react drills for targeting, stacking, and switching communication.",
        spots_total: 12,
        training_program: programs[2]
      },
      {
        title: "Weekend Skills Camp",
        cwday: 6,
        hour: 9,
        minute: 0,
        duration_minutes: 120,
        location: "Private Court",
        skill_level: "All levels",
        notes: "Structured stations for serves, drops, dinks, and live pattern repetition.",
        spots_total: 16,
        training_program: nil
      },
      {
        title: "Weekend Matchplay Lab",
        cwday: 6,
        hour: 11,
        minute: 30,
        duration_minutes: 120,
        location: "Private Court",
        skill_level: "Intermediate / Advanced",
        notes: "Competitive games with tactical pauses, score-pressure reps, and video review.",
        spots_total: 14,
        training_program: programs[2]
      },
      {
        title: "Sunday Open Play Review",
        cwday: 7,
        hour: 10,
        minute: 0,
        duration_minutes: 120,
        location: "Private Court",
        skill_level: "All levels",
        notes: "Live play rounds with immediate coaching feedback and customized adjustments.",
        spots_total: 16,
        training_program: nil
      }
    ]

    start_date = backfill_months.months.ago.to_date.beginning_of_week(:monday)
    end_date = forward_months.months.from_now.to_date.end_of_week(:monday)

    week_index = 0
    start_date.step(end_date, 7) do |week_start|
      session_templates.each_with_index do |template, template_index|
        session_date = week_start + (template[:cwday] - 1).days
        next if session_date < start_date || session_date > end_date

        starts_at = Time.zone.local(session_date.year, session_date.month, session_date.day, template[:hour], template[:minute])
        ends_at = starts_at + template[:duration_minutes].minutes

        occupancy_ratio =
          if starts_at < Time.current
            0.62 + (((week_index + template_index) % 25) / 100.0)
          else
            0.25 + (((week_index + template_index) % 30) / 100.0)
          end

        spots_booked = (template[:spots_total] * occupancy_ratio).floor
        spots_booked = [spots_booked, template[:spots_total] - 1].min

        TrainingSession.create!(
          title: template[:title],
          starts_at: starts_at,
          ends_at: ends_at,
          location: template[:location],
          skill_level: template[:skill_level],
          notes: template[:notes],
          spots_total: template[:spots_total],
          spots_booked: spots_booked,
          coach: coach,
          training_program: template[:training_program]
        )
      end

      week_index += 1
    end

    puts "Seeded #{Coach.count} coach, #{TrainingProgram.count} programs, and #{TrainingSession.count} training sessions from #{start_date} to #{end_date}."
  end
end
