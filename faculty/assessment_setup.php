<style>
    :root {
        --primary: #3B82F6;
        --primary-dark: #1E40AF;
        --secondary: #10B981;
        --accent: #F59E0B;
        --danger: #EF4444;
        --success: #22C55E;
        --surface: #FFFFFF;
        --background: #F8FAFC;
        --text-primary: #1E293B;
        --text-secondary: #64748B;
        --border: #E2E8F0;
        --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        --radius: 12px;
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    body, .main-content {
        background: var(--background);
    }
    .page-header {
        margin-bottom: 2rem;
    }
    .page-header h2 {
        font-size: 1.6rem;
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: 0.5rem;
    }
    .page-header p {
        color: var(--text-secondary);
        font-size: 0.9rem;
    }
    .alert-card {
        padding: 1rem 1.5rem;
        border-radius: var(--radius);
        margin-bottom: 2rem;
        border: 1px solid;
        position: relative;
        animation: slideIn 0.3s ease-out;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    @keyframes slideIn {
        from { transform: translateY(-10px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    .alert-success {
        background: rgba(34, 197, 94, 0.1);
        border-color: var(--success);
        color: #166534;
    }
    .alert-error {
        background: rgba(239, 68, 68, 0.1);
        border-color: var(--danger);
        color: #991b1b;
    }
    .table-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        box-shadow: var(--shadow);
        margin-bottom: 2rem;
        overflow: hidden;
        transition: var(--transition);
    }
    .table-card:hover {
        box-shadow: var(--shadow-lg);
        border-color: var(--primary);
    }
    .subject-title {
        padding: 1rem 1.25rem;
        border-bottom: 1px solid var(--border);
        display: flex;
        flex-direction: column;
    }
    .title {
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-primary);
    }
    .subtitle {
        font-size: 0.9rem;
        color: var(--text-secondary);
        margin-top: 0.25rem;
    }
    .table-wrap {
        overflow-x: auto;
    }
    .grades-table {
        width: 100%;
        border-collapse: collapse;
    }
    .grades-table thead {
        background: var(--background);
        border-bottom: 1px solid var(--border);
    }
    .grades-table th {
        padding: 1rem 1.25rem;
        text-align: center;
        font-weight: 700;
        color: var(--text-secondary);
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }
    .grades-table td {
        padding: 1rem 1.25rem;
        vertical-align: middle;
        color: var(--text-primary);
        text-align: center;
    }
    .grades-table input[type="text"],
    .grades-table input[type="number"] {
        padding: 0.5rem 0.75rem;
        border: 2px solid var(--border);
        border-radius: 8px;
        font-size: 1rem;
        background: var(--surface);
        color: var(--text-primary);
        transition: var(--transition);
        width: 100%;
        box-sizing: border-box;
    }
    .grades-table input[type="text"]:focus,
    .grades-table input[type="number"]:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }
    .grades-table button {
        padding: 0.5rem 1rem;
        background: linear-gradient(135deg, var(--primary), var(--primary-dark));
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 0.9rem;
        font-weight: 600;
        cursor: pointer;
        transition: var(--transition);
        margin-right: 0.5rem;
    }
    .grades-table button:last-child {
        margin-right: 0;
    }
    .grades-table button:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow);
    }
    .grades-table button:active {
        transform: translateY(0);
    }
    @media (max-width: 768px) {
        .table-card {
            padding: 1rem;
        }
        .grades-table th,
        .grades-table td {
            padding: 0.75rem 0.5rem;
        }
    }
</style>

<?php
require_once __DIR__ . '/../includes/auth_check.php';
require_once __DIR__ . '/../includes/rbac.php';
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../includes/flash.php';
requireRole([1]);

$faculty_id = $_SESSION['user_id'];
$message = '';
$msg_type = 'success';
if ($flash = getFlash()) {
    $message = $flash['msg'];
    $msg_type = $flash['type'];
}

// Fetch faculty subjects
$subjects = [];
$stmt = $conn->prepare("SELECT subject_id, subject_code, subject_name FROM subjects WHERE faculty_id = ? ORDER BY subject_name");
$stmt->bind_param("i", $faculty_id);
$stmt->execute();
$result = $stmt->get_result();
while ($row = $result->fetch_assoc()) {
    $subjects[] = $row;
}
$stmt->close();

// Fetch components for each subject
$subject_components = [];
foreach ($subjects as $subj) {
    $stmt = $conn->prepare("SELECT * FROM assessment_components WHERE subject_id = ? ORDER BY component_id");
    $stmt->bind_param("i", $subj['subject_id']);
    $stmt->execute();
    $result = $stmt->get_result();
    $subject_components[$subj['subject_id']] = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
}
?>

<div class="page-header">
    <h2>Assessment Components Setup</h2>
    <p>Define and customize grading components and weights for each subject.</p>
</div>
<?php if ($message): ?>
    <div class="alert-card <?= $msg_type === 'error' ? 'alert-error' : 'alert-success' ?>">
        <?= htmlspecialchars($message, ENT_QUOTES) ?>
    </div>
<?php endif; ?>

<?php foreach ($subjects as $subject): ?>
    <div class="table-card" style="margin-bottom:2rem;">
        <div class="subject-title">
            <div class="title"><?= htmlspecialchars($subject['subject_code'], ENT_QUOTES) ?></div>
            <div class="subtitle">Assessment Components</div>
        </div>
        <div class="table-wrap">
            <table class="grades-table">
                <thead>
                    <tr>
                        <th>Component Name</th>
                        <th>Weight (%)</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($subject_components[$subject['subject_id']] as $comp): ?>
                        <tr>
                            <form method="POST">
                                <td>
                                    <input type="text" name="component_name" value="<?= htmlspecialchars($comp['component_name'], ENT_QUOTES) ?>" required>
                                </td>
                                <td>
                                    <input type="number" name="weight" value="<?= $comp['weight'] ?>" min="1" max="100" step="0.01" required>
                                </td>
                                <td>
                                    <input type="hidden" name="subject_id" value="<?= $subject['subject_id'] ?>">
                                    <input type="hidden" name="component_id" value="<?= $comp['component_id'] ?>">
                                    <button type="submit" name="action" value="edit">Save</button>
                                    <button type="submit" name="action" value="delete" onclick="return confirm('Delete this component?')">Delete</button>
                                </td>
                            </form>
                        </tr>
                    <?php endforeach; ?>
                    <tr>
                        <form method="POST">
                            <td><input type="text" name="component_name" placeholder="e.g. Quiz" required></td>
                            <td><input type="number" name="weight" min="1" max="100" step="0.01" required></td>
                            <td>
                                <input type="hidden" name="subject_id" value="<?= $subject['subject_id'] ?>">
                                <button type="submit" name="action" value="add">Add</button>
                            </td>
                        </form>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
<?php endforeach; ?>
