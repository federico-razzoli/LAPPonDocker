<?php

require_once('../conf/db.php');


define('NL', "<br>\n");
define('TEST_SQL', 'SELECT version() AS version;');


function fail($message) {
    echo '<strong>[FAIL]</strong> ' . htmlentities($message) . NL;
    exit();
}

function PDOFail($PDOException, $message) {
    fail(
        $message . ' ' .
        'PDO error code: '  . $PDOException->getCode() . '; ' .
        'error message: '   . htmlentities($PDOException->getMessage())
    );
}

function success() {
    echo
        'Connection to PostgreSQL successfully established' . NL .
        '<strong>SUCCESS</strong>' . NL;
}


if (!extension_loaded('pdo')) {
    fail('PDO extension is not installed');
}

#if (!extension_loaded('pdo_pgsql')) {
#    fail('PDO PostgreSQL driver is not installed');
#}

echo 'PDO extension and PostgreSQL driver are installed' . NL;

try {
    $dbh = new PDO(PG_DSN);
} catch (PDOException $e){
    PDOFail($e, 'Could not connect to PostgreSQL.');
}

if (!$dbh) {
    fail('Could not connect to PostgreSQL');
}

try {
    $result = $dbh->query(TEST_SQL);
} catch (PDOException $e){
    PDOFail($e, 'Could not execute query.');
}

echo success('SUCCESS');

echo NL;
$row = $result->fetch(PDO::FETCH_ASSOC);
echo 'PostgreSQL version: ' . $row['version'];

$row = null;
$result = null;
$dbh = null;

//EOF
