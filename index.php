<?php
require_once __DIR__ . '/includes/session.php';
require_once __DIR__ . '/includes/rbac.php';
require_once __DIR__ . '/config/db.php';
require_once __DIR__ . '/includes/audit.php';
require_once __DIR__ . '/includes/csrf.php';

// Prevent caching for protected content
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Pragma: no-cache");
header("Expires: 0");

// ensure authenticated
if (!isset($_SESSION["user_id"], $_SESSION["role_id"])) {
    header("Location: auth/login.php");
    exit;
}

$role_id = (int)$_SESSION["role_id"];
$page = $_GET['page'] ?? 'dashboard';

// Handle POST for assessment_setup before any output
if ($page === 'assessment_setup' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    requireRole([1]);
    require_once __DIR__ . '/config/db.php';
    require_once __DIR__ . '/includes/flash.php';
    $subject_id = (int)($_POST['subject_id'] ?? 0);
    $component_id = (int)($_POST['component_id'] ?? 0);
    $name = trim($_POST['component_name'] ?? '');
    $weight = (float)($_POST['weight'] ?? 0);
    $action = $_POST['action'] ?? '';
    if ($subject_id > 0) {
        if ($action === 'add' && $name && $weight > 0) {
            $stmt = $conn->prepare("INSERT INTO assessment_components (subject_id, component_name, weight) VALUES (?, ?, ?)");
            $stmt->bind_param("isd", $subject_id, $name, $weight);
            $stmt->execute();
            $stmt->close();
            setFlash('Component added.','success');
        } elseif ($action === 'edit' && $component_id > 0 && $name && $weight > 0) {
            $stmt = $conn->prepare("UPDATE assessment_components SET component_name=?, weight=? WHERE component_id=? AND subject_id=?");
            $stmt->bind_param("sdii", $name, $weight, $component_id, $subject_id);
            $stmt->execute();
            $stmt->close();
            setFlash('Component updated.','success');
        } elseif ($action === 'delete' && $component_id > 0) {
            $stmt = $conn->prepare("DELETE FROM assessment_components WHERE component_id=? AND subject_id=?");
            $stmt->bind_param("ii", $component_id, $subject_id);
            $stmt->execute();
            $stmt->close();
            setFlash('Component deleted.','success');
        }
        header('Location: ?page=assessment_setup');
        exit;
    }
}
?>
<?php
// central router after login, consolidating previous dashboard/index.php
require_once __DIR__ . '/includes/session.php';
require_once __DIR__ . '/includes/rbac.php';
require_once __DIR__ . '/config/db.php';
require_once __DIR__ . '/includes/audit.php';
require_once __DIR__ . '/includes/csrf.php';

// Prevent caching for protected content
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Pragma: no-cache");
header("Expires: 0");

// ensure authenticated
if (!isset($_SESSION["user_id"], $_SESSION["role_id"])) {
    header("Location: auth/login.php");
    exit;
}

$role_id = (int)$_SESSION["role_id"];
$page = $_GET['page'] ?? 'dashboard';

// Handle POST-only handlers before rendering sidebar (to prevent headers-already-sent errors)
if ($page === 'request_correction' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    requireRole([1]);
    ob_start();
    include __DIR__ . '/faculty/request_correction.php';
    ob_end_clean();
    exit;
}

// include sidebar (role-based) and output layout wrapper
include __DIR__ . '/template/sidebar.php';
?>
            <div style="max-width: 1400px; margin: 0 auto;">
                <?php
                switch ($page) {
                                        case 'assessment_setup':
                                            requireRole([1]);
                                            ob_start();
                                            include __DIR__ . '/faculty/assessment_setup.php';
                                            echo ob_get_clean();
                                            break;
                    case 'dashboard':
                        if ($role_id === 1) {
                            ob_start();
                            include __DIR__ . '/faculty/dashboard.php';
                            echo ob_get_clean();
                        } elseif ($role_id === 2) {
                            ob_start();
                            include __DIR__ . '/registrar/dashboard.php';
                            echo ob_get_clean();
                        } elseif ($role_id === 3) {
                            ob_start();
                            include __DIR__ . '/student/dashboard.php';
                            echo ob_get_clean();
                        } elseif ($role_id === 4) {
                            ob_start();
                            include __DIR__ . '/admin/dashboard.php';
                            echo ob_get_clean();
                        }
                        break;

                    // Faculty pages
                    case 'subjects':
                        requireRole([1]);
                        echo '<h2>My Assigned Subjects</h2>';
                        echo '<p>Subject list would go here</p>';
                        break;
                    case 'submit_grades':
                        requireRole([1]);
                        ob_start();
                        include __DIR__ . '/faculty/submit_grades.php';
                        echo ob_get_clean();
                        break;
                    case 'view_grades':
                        if ($role_id === 1) {
                            requireRole([1]);
                            ob_start();
                            include __DIR__ . '/faculty/grade_sheet.php';
                            echo ob_get_clean();
                        } else {
                            requireRole([3]);
                            ob_start();
                            include __DIR__ . '/student/view_grades.php';
                            echo ob_get_clean();
                        }
                        break;
                    case 'request_correction':
                        requireRole([1]);
                        ob_start();
                        include __DIR__ . '/faculty/request_correction.php';
                        echo ob_get_clean();
                        break;

                    // Registrar pages
                    case 'pending_enrollments':
                        requireRole([2]);
                        ob_start();
                        include __DIR__ . '/registrar/pending_enrollments.php';
                        echo ob_get_clean();
                        break;
                    case 'pending_grades':
                        requireRole([2]);
                        ob_start();
                        include __DIR__ . '/registrar/pending_grades.php';
                        echo ob_get_clean();
                        break;
                    case 'pending_corrections':
                        requireRole([2]);
                        ob_start();
                        include __DIR__ . '/registrar/approve_correction.php';
                        echo ob_get_clean();
                        break;

                    // Student pages
                    case 'request_enrollment':
                        requireRole([3]);
                        ob_start();
                        include __DIR__ . '/student/enrollment_request.php';
                        echo ob_get_clean();
                        break;
                    case 'enrollment_status':
                        requireRole([3]);
                        ob_start();
                        include __DIR__ . '/student/enrollment_status.php';
                        echo ob_get_clean();
                        break;

                    // Admin pages
                    case 'user_management':
                        requireRole([4]);
                        ob_start();
                        include __DIR__ . '/admin/user_management.php';
                        echo ob_get_clean();
                        break;
                    case 'grade_reports':
                        requireRole([4]);
                        ob_start();
                        include __DIR__ . '/admin/grade_reports.php';
                        echo ob_get_clean();
                        break;
                    case 'audit_logs':
                        requireRole([4]);
                        ob_start();
                        include __DIR__ . '/admin/audit_logs.php';
                        echo ob_get_clean();
                        break;

                    // Shared

                    default:
                        if ($role_id === 1) {
                            ob_start();
                            include __DIR__ . '/faculty/dashboard.php';
                            echo ob_get_clean();
                        } elseif ($role_id === 2) {
                            ob_start();
                            include __DIR__ . '/registrar/dashboard.php';
                            echo ob_get_clean();
                        } elseif ($role_id === 3) {
                            ob_start();
                            include __DIR__ . '/student/dashboard.php';
                            echo ob_get_clean();
                        } elseif ($role_id === 4) {
                            ob_start();
                            include __DIR__ . '/admin/dashboard.php';
                            echo ob_get_clean();
                        }
                }
                ?>
            </div>
        </main>
    </div>
</body>
</html>