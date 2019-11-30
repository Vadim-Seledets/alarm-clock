
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name Clock -dir "E:/University/7 semestr/POTSP/L6/Add/alarm-clock/Source/planAhead_run_1" -part xc6slx9tqg144-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/University/7 semestr/POTSP/L6/Add/alarm-clock/Source/AlarmClock.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/University/7 semestr/POTSP/L6/Add/alarm-clock/Source} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "AlarmClock.ucf" [current_fileset -constrset]
add_files [list {AlarmClock.ucf}] -fileset [get_property constrset [current_run]]
link_design
