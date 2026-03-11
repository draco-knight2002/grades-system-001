-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 11, 2026 at 06:24 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `grades_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `assessment_components`
--

CREATE TABLE `assessment_components` (
  `component_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `component_name` varchar(50) NOT NULL,
  `weight` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `action_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`log_id`, `user_id`, `action`, `action_time`) VALUES
(1, 7, 'User logged in', '2026-03-06 05:30:01'),
(2, 7, 'Viewed pending enrollment requests', '2026-03-06 05:30:59'),
(3, 8, 'User logged in', '2026-03-06 05:41:30'),
(4, 7, 'User logged in', '2026-03-06 06:14:58'),
(5, 11, 'User logged in', '2026-03-06 06:15:15'),
(6, 2, 'User logged in', '2026-03-06 06:39:44'),
(7, 11, 'User logged in', '2026-03-06 07:01:51'),
(8, 8, 'User logged in', '2026-03-06 07:30:29'),
(9, 8, 'Submitted enrollment request for subject 2', '2026-03-06 08:01:16'),
(10, 8, 'Submitted enrollment request for subject 5', '2026-03-06 08:01:19'),
(11, 8, 'Submitted enrollment request for subject 4', '2026-03-06 08:01:23'),
(12, 2, 'User logged in', '2026-03-06 08:01:34'),
(13, 11, 'User logged in', '2026-03-06 08:01:55'),
(14, 7, 'User logged in', '2026-03-06 08:02:57'),
(15, 7, 'Viewed pending enrollment requests', '2026-03-06 08:03:00'),
(16, 7, 'Viewed pending correction requests', '2026-03-06 08:03:05'),
(17, 7, 'Viewed pending enrollment requests', '2026-03-06 08:03:07'),
(18, 8, 'User logged in', '2026-03-11 15:15:15'),
(19, 2, 'User logged in', '2026-03-11 15:16:17'),
(20, 8, 'User logged in', '2026-03-11 16:12:40'),
(21, 7, 'User logged in', '2026-03-11 16:13:02'),
(22, 7, 'Viewed pending enrollment requests', '2026-03-11 16:13:05'),
(23, 7, 'Approved enrollment request 1', '2026-03-11 16:13:10'),
(24, 7, 'Viewed pending enrollment requests', '2026-03-11 16:13:11'),
(25, 8, 'User logged in', '2026-03-11 16:24:29');

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `enrollment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `semester_id` int(11) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`enrollment_id`, `student_id`, `subject_id`, `semester_id`, `status`) VALUES
(1, 8, 2, 2, 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_requests`
--

CREATE TABLE `enrollment_requests` (
  `request_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `decision_date` timestamp NULL DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `decision_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollment_requests`
--

INSERT INTO `enrollment_requests` (`request_id`, `student_id`, `subject_id`, `status`, `request_date`, `decision_date`, `registrar_id`, `decision_notes`) VALUES
(1, 8, 2, 'Approved', '2026-03-06 08:01:16', '2026-03-11 16:13:10', 7, ''),
(2, 8, 5, 'Pending', '2026-03-06 08:01:19', NULL, NULL, NULL),
(3, 8, 4, 'Pending', '2026-03-06 08:01:23', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grade_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `academic_period` varchar(50) NOT NULL DEFAULT '3rd Year - 2nd Semester',
  `percentage` decimal(5,2) NOT NULL,
  `numeric_grade` decimal(3,2) NOT NULL,
  `remarks` varchar(20) NOT NULL,
  `status` enum('Pending','Returned','Approved') DEFAULT 'Pending',
  `is_locked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grade_components`
--

CREATE TABLE `grade_components` (
  `grade_component_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `academic_period` varchar(50) NOT NULL,
  `component_id` int(11) NOT NULL,
  `raw_score` decimal(6,2) NOT NULL,
  `max_score` decimal(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grade_corrections`
--

CREATE TABLE `grade_corrections` (
  `request_id` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `faculty_id` int(11) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `registrar_id` int(11) DEFAULT NULL,
  `decision_notes` text DEFAULT NULL,
  `decision_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `message`, `is_read`, `created_at`) VALUES
(1, 8, 'Your enrollment request #1 was approved.', 0, '2026-03-11 16:13:10');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(4, 'Admin'),
(1, 'Faculty'),
(2, 'Registrar'),
(3, 'Student');

-- --------------------------------------------------------

--
-- Table structure for table `semesters`
--

CREATE TABLE `semesters` (
  `semester_id` int(11) NOT NULL,
  `semester_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `semesters`
--

INSERT INTO `semesters` (`semester_id`, `semester_name`) VALUES
(1, 'First Semester'),
(2, 'Second Semester');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `subject_id` int(11) NOT NULL,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `faculty_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`subject_id`, `subject_code`, `subject_name`, `faculty_id`) VALUES
(1, 'SP101', 'Social and Professional Issues', 1),
(2, 'IAS102', 'Information Assurance and Security 2', 2),
(3, 'TEC101', 'Technopreneurship', 3),
(4, 'PM101', 'Business Process Management in IT', 4),
(5, 'ITSP2A', 'Mobile Application and Development', 5),
(6, 'SA101', 'System Administration And Maintenance', 6);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `program` varchar(100) DEFAULT NULL,
  `section` varchar(50) DEFAULT NULL,
  `year_level` tinyint(4) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `program`, `section`, `year_level`, `email`, `password_hash`, `role_id`, `created_at`, `is_active`) VALUES
(1, 'Jacqueline De Guzman', NULL, NULL, NULL, 'jacqueline.faculty@gmail.com', '$2y$10$oF94e4rJ.3I35Y0y7AubM.j8rXDVk/eDWi0Dr5y23imGK8TXWg4BO', 1, '2026-02-25 11:55:09', 1),
(2, 'Andrew Delacruz', NULL, NULL, NULL, 'andrew.faculty@gmail.com', '$2y$10$UI9UGiAMDZ/KKGinvalEh.MW7T.XP5quI1CIMxTyEa.O.S54w90QO', 1, '2026-02-25 11:56:58', 1),
(3, 'Marimel Loya', NULL, NULL, NULL, 'marimel.faculty@gmail.com', '$2y$10$NGfJOjXlAB1kIXLiLbwHO.sOF4aoilu5swLolOhlSbxUL7owBn6gG', 1, '2026-02-25 11:57:51', 1),
(4, 'Jorge Lucero', NULL, NULL, NULL, 'jorge.faculty@gmail.com', '$2y$10$NeesYvAJWn3mCPJLswzN5uMzgYFF9RnUSJeq2knesEOSkLXJagnr6', 1, '2026-02-25 11:58:57', 1),
(5, 'Jessa Brogada', NULL, NULL, NULL, 'jessa.faculty@gmail.com', '$2y$10$8Z.9dD4ioG5u0mgqkJ4D8.lIk5LQDZCcKAd7MXOClufqs8Zz8hMTq', 1, '2026-02-25 11:59:35', 1),
(6, 'Regane Macahibag', NULL, NULL, NULL, 'regane.faculty@gmail.com', '$2y$10$AZJAx4d6CpMdg5/ynSpcPONnxKotoR1Ju6k.1ECwayLHHw33r0x7m', 1, '2026-02-25 12:00:20', 1),
(7, 'Eva Arce', NULL, NULL, NULL, 'eva.registrar@gmail.com', '$2y$10$1.G8TngCS/DesxJ1C001t.RQaQ/33zfuKF590Act5U0imcIYyh64i', 2, '2026-02-25 12:01:50', 1),
(8, 'Yuan Amboy', 'Bachelor of Science in Information Technology', 'BSIT-32011-IM', 3, 'yuan.student@gmail.com', '$2y$10$RDwalh4Be87BFTC3TFnvD.ChJVPmBnIecdzqSrSlDYnLjcbKpUPza', 3, '2026-02-25 12:05:33', 1),
(9, 'Roberto Fuentes', 'Bachelor of Science in Information Technology', 'BSIT-32011-IM', 3, 'roberto.student@gmail.com', '$2y$10$m9xGsiOC7DTd6q/rpCCRMO0lclg5s/eynIGPFVxFdN2MlDfsDs2j6', 3, '2026-03-04 14:00:29', 1),
(10, 'Carl Garcia', 'Bachelor of Science in Information Technology', 'BSIT-32011-IM', 3, 'carl.student@gmail.com', '$2y$10$4s4wuxzvitObJLzuIRjuG.CWIcH.wgp7v2dGZxs59O.VuooM03qNu', 3, '2026-03-05 10:06:23', 1),
(11, 'Espada Admin', NULL, NULL, NULL, 'espada.admin@gmail.com', '$2y$10$FOF2NjMXzE8bJReNSqg93uOLQaBbA10LBBFAFDbKm2wHXMz9jbC02', 4, '2026-03-05 19:18:37', 1),
(12, 'Adrian Aseo', 'Bachelor of Science in Information Technology', 'BSIT-32011-IM', 3, 'adrian.student@gmail.com', '$2y$10$Fi3kKBlVleLhsWfwPHUaP.Dhftc2giL9WRPdkujiLsV76geE3wO3e', 3, '2026-03-05 19:46:46', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assessment_components`
--
ALTER TABLE `assessment_components`
  ADD PRIMARY KEY (`component_id`),
  ADD KEY `fk_ac_subject` (`subject_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `semester_id` (`semester_id`);

--
-- Indexes for table `enrollment_requests`
--
ALTER TABLE `enrollment_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `registrar_id` (`registrar_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grade_id`),
  ADD UNIQUE KEY `unique_grade` (`student_id`,`subject_id`,`academic_period`),
  ADD KEY `grades_fk_subject` (`subject_id`);

--
-- Indexes for table `grade_components`
--
ALTER TABLE `grade_components`
  ADD PRIMARY KEY (`grade_component_id`),
  ADD KEY `fk_gc_student` (`student_id`),
  ADD KEY `fk_gc_subject` (`subject_id`),
  ADD KEY `fk_gc_component` (`component_id`);

--
-- Indexes for table `grade_corrections`
--
ALTER TABLE `grade_corrections`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `grade_id` (`grade_id`),
  ADD KEY `faculty_id` (`faculty_id`),
  ADD KEY `registrar_id` (`registrar_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indexes for table `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`semester_id`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`subject_id`),
  ADD KEY `faculty_id` (`faculty_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assessment_components`
--
ALTER TABLE `assessment_components`
  MODIFY `component_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `enrollment_requests`
--
ALTER TABLE `enrollment_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grade_components`
--
ALTER TABLE `grade_components`
  MODIFY `grade_component_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grade_corrections`
--
ALTER TABLE `grade_corrections`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `semesters`
--
ALTER TABLE `semesters`
  MODIFY `semester_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assessment_components`
--
ALTER TABLE `assessment_components`
  ADD CONSTRAINT `fk_ac_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`);

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`),
  ADD CONSTRAINT `enrollments_ibfk_3` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`semester_id`);

--
-- Constraints for table `enrollment_requests`
--
ALTER TABLE `enrollment_requests`
  ADD CONSTRAINT `enrollment_requests_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `enrollment_requests_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`),
  ADD CONSTRAINT `enrollment_requests_ibfk_3` FOREIGN KEY (`registrar_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_fk_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `grades_fk_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`);

--
-- Constraints for table `grade_components`
--
ALTER TABLE `grade_components`
  ADD CONSTRAINT `fk_gc_component` FOREIGN KEY (`component_id`) REFERENCES `assessment_components` (`component_id`),
  ADD CONSTRAINT `fk_gc_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `fk_gc_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`);

--
-- Constraints for table `grade_corrections`
--
ALTER TABLE `grade_corrections`
  ADD CONSTRAINT `grade_corrections_ibfk_1` FOREIGN KEY (`grade_id`) REFERENCES `grades` (`grade_id`),
  ADD CONSTRAINT `grade_corrections_ibfk_2` FOREIGN KEY (`faculty_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `grade_corrections_ibfk_3` FOREIGN KEY (`registrar_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `subjects`
--
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`faculty_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
