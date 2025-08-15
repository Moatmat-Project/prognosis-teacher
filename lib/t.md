Database Functions to Create
Group 1: SQL Functions (Simple Data Retrieval & Basic Operations)
These functions handle simple queries without complex logic:
Authentication & Users
get_teacher_by_email(teacher_email TEXT)
Returns: Teacher data record
Purpose: Get teacher information by email with built-in authentication check
get_user_by_id(user_id TEXT, is_uuid BOOLEAN)
Returns: User data record
Purpose: Get user data by ID or UUID
get_users_by_ids(user_ids TEXT[], is_uuid BOOLEAN)
Returns: TABLE of user records
Purpose: Batch retrieve users by IDs
Tests & Banks
get_teacher_tests(teacher_email TEXT)
Returns: TABLE of test records
Purpose: Get all tests for a specific teacher
get_teacher_banks(teacher_email TEXT)
Returns: TABLE of bank records
Purpose: Get all banks for a specific teacher
get_test_by_id(test_id INTEGER, teacher_email TEXT)
Returns: Test record
Purpose: Get test with ownership verification
get_bank_by_id(bank_id INTEGER, teacher_email TEXT)
Returns: Bank record
Purpose: Get bank with ownership verification
get_tests_by_ids(test_ids INTEGER[])
Returns: TABLE of test records
Purpose: Batch retrieve tests
get_banks_by_ids(bank_ids INTEGER[])
Returns: TABLE of bank records
Purpose: Batch retrieve banks
Results & Statistics
get_student_results(student_id TEXT, teacher_email TEXT)
Returns: TABLE of result records
Purpose: Get all results for a student under specific teacher
get_repository_results(repo_type TEXT, repo_id INTEGER)
Returns: TABLE of result records
Purpose: Get results for test/bank/outer_test
get_repository_average(repo_type TEXT, repo_id INTEGER)
Returns: DECIMAL
Purpose: Calculate average score for repository
Purchases
get_test_purchases(test_id INTEGER)
Returns: TABLE of purchase records
Purpose: Get all purchases for a test
get_bank_purchases(bank_id INTEGER)
Returns: TABLE of purchase records
Purpose: Get all purchases for a bank
get_teacher_purchases(teacher_email TEXT)
Returns: TABLE of purchase records
Purpose: Get all course purchases for teacher
Outer Tests
get_teacher_outer_tests(teacher_email TEXT)
Returns: TABLE of outer test records
Purpose: Get outer tests for teacher
get_outer_test_by_id(outer_test_id INTEGER, teacher_email TEXT)
Returns: Outer test record
Purpose: Get outer test with ownership verification
Reports
get_teacher_reports(teacher_email TEXT)
Returns: TABLE of report records
Purpose: Get reports for teacher
Attendance
get_teacher_attendance_sets(teacher_email TEXT)
Returns: TABLE of attendance set records
Purpose: Get attendance sets for teacher
get_attendance_records(set_id INTEGER, teacher_email TEXT)
Returns: TABLE of attendance records
Purpose: Get attendance records with authorization
get_student_attendance_records(student_id TEXT)
Returns: TABLE of attendance records
Purpose: Get all attendance records for a student
Group 2: PL/pgSQL Functions (Complex Logic & Data Processing)
These functions handle complex business logic, data validation, and multi-table operations:
Student Management & Statistics
get_teacher_students_with_stats(teacher_email TEXT, exclude_course_subscribers BOOLEAN, exclude_banks BOOLEAN, exclude_tests BOOLEAN)
Returns: Complex result set with student data and statistics
Purpose: Replace the complex getMyStudents logic with optimized database function
get_students_statistics(teacher_email TEXT, student_ids TEXT[])
Returns: Complex statistics data structure
Purpose: Generate comprehensive student statistics with tests, attendance, and performance data
search_teacher_students(teacher_email TEXT, search_text TEXT)
Returns: TABLE of filtered user records
Purpose: Search in teacher's students with complex filtering logic
get_repository_students(repo_type TEXT, repo_id INTEGER)
Returns: TABLE of user records who took the test/bank
Purpose: Get students who participated in specific repository
Data Validation & Security
verify_teacher_ownership(teacher_email TEXT, resource_type TEXT, resource_id INTEGER)
Returns: BOOLEAN
Purpose: Verify teacher owns the specified resource (test/bank/outer_test)
validate_attendance_access(teacher_email TEXT, set_id INTEGER)
Returns: BOOLEAN
Purpose: Validate teacher can access attendance set
can_access_student_data(teacher_email TEXT, student_id TEXT)
Returns: BOOLEAN
Purpose: Check if teacher can access student's data
Bulk Operations
bulk_insert_results(results_data JSONB)
Returns: INTEGER (count of inserted records)
Purpose: Handle bulk result insertion with validation and user lookup
bulk_delete_results(result_ids INTEGER[], teacher_email TEXT)
Returns: INTEGER (count of deleted records)
Purpose: Safely delete multiple results with ownership verification
bulk_insert_attendance_records(attendance_data JSONB, teacher_email TEXT)
Returns: INTEGER (count of inserted records)
Purpose: Handle bulk attendance record insertion with validation
Complex Attendance Operations
sync_attendance_sets(local_sets JSONB, teacher_email TEXT)
Returns: JSONB (sync results)
Purpose: Handle complex attendance sync from offline to online
create_attendance_set_with_records(set_data JSONB, records_data JSONB, teacher_email TEXT)
Returns: INTEGER (new set ID)
Purpose: Atomically create attendance set and records
Notification Management
send_notification_to_user(user_id TEXT, notification_data JSONB)
Returns: BOOLEAN
Purpose: Add notification to user's notification array
send_bulk_notifications(user_ids TEXT[], notification_data JSONB)
Returns: INTEGER (count of notifications sent)
Purpose: Send notification to multiple users efficiently
Advanced Statistics & Analytics
calculate_repository_statistics(repo_type TEXT, repo_id INTEGER)
Returns: JSONB (comprehensive statistics)
Purpose: Calculate detailed statistics for tests/banks including averages, distributions, etc.
get_teacher_dashboard_data(teacher_email TEXT)
Returns: JSONB (dashboard summary)
Purpose: Get comprehensive dashboard data in single call
analyze_student_performance(student_id TEXT, teacher_email TEXT)
Returns: JSONB (performance analysis)
Purpose: Analyze individual student performance across all assessments
Data Cleanup & Maintenance
cleanup_orphaned_records(teacher_email TEXT)
Returns: JSONB (cleanup summary)
Purpose: Clean up orphaned records for teacher's data
archive_old_data(teacher_email TEXT, cutoff_date DATE)
Returns: INTEGER (archived count)
Purpose: Archive old results and attendance records
Group & Course Management
manage_group_students(group_id INTEGER, operation TEXT, student_data JSONB, teacher_email TEXT)
Returns: BOOLEAN
Purpose: Handle adding/removing students from groups
update_course_subscriber_tests(teacher_email TEXT, test_ids INTEGER[])
Returns: BOOLEAN
Purpose: Update course subscriber accessible tests
Key Benefits of This Approach:
Security: All functions include teacher authentication and authorization checks
Performance: Complex queries are optimized at database level
Data Integrity: Transactions ensure atomic operations
Maintainability: Business logic centralized in database
Scalability: Reduced network traffic and app processing
Implementation Priority:
High Priority (Core Operations):
Functions 22, 23 (Student management)
Functions 26, 27, 28 (Security validation)
Functions 1, 6, 7 (Basic data access)
Medium Priority (Performance Optimization):
Functions 29, 30, 31 (Bulk operations)
Functions 32, 33 (Attendance sync)
Functions 36, 37 (Statistics)
Low Priority (Advanced Features):
Functions 38, 39, 40 (Analytics & cleanup)
Functions 41, 42 (Group management)
This comprehensive approach will significantly improve your app's security, performance, and maintainability by moving complex logic to the database level where it belongs.