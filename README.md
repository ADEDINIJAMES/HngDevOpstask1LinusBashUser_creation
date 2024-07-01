                                              LINUX USER CREATION BASH SCRIPT
                                              
 INTRODUCTION
 As businesses scale and onboard new team members, managing user accounts across multiple Linux servers becomes increasingly complex.
 Our bash script aims to streamline this process by reading a user list file, creating users with home directories, generating random passwords, assigning user-specific groups, and logging all actions for accountability.

 SCRIPT EXECUTION FLOW
 1. Directory Setup: Ensures the necessary log and secure directories (LOG_DIR and SECURE_DIR) exist with appropriate permissions (chmod 700).

 2. User List Validation: Checks if the user list file ($USER_LIST_FILE) exists and is accessible.

 3. User Management: Iterates through each line in the user list file:
  -  Checks if the user already exists.
  -  Creates the user with a home directory and assigns a personal group.
  -  Generates a random password, sets it for the user, and logs the action.
  - Assigns additional specified groups to the user.

  4. Security Measures: Secures the password file (user_passwords.csv) by restricting access to root (chown root:root and chmod 600).

 ERROR HANDLING AND SECURITY
 The script includes robust error handling to skip user creation if the user already exists and ensures groups are only created when necessary. Logging (log_message function) tracks all operations, aiding in troubleshooting and auditing.

 CONCLUSION
 Automating Linux user management tasks with bash scripting boosts operational efficiency and ensures high security by managing access controls and password protections effectively. This script serves as a practical example of applying DevOps principles to streamline IT infrastructure maintenance.

 To join HNG internship visit 
  https://hng.tech/internship, https://hng.tech/hire
