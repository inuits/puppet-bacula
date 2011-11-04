import 'classes/*'
import 'definitions/*'

class bacula (
	$admin_email,
	$operator_email,
	$director_server = 'bacula',
	$director_label = 'bacula-dir',
	$director_password = 'bacula',
	$storage_server = 'bacula',
	$storage_label = 'bacula-sd',
	$storage_password = 'bacula',
	$storage_dir = '/mnt/backup',
	$dbname = 'bacula',
	$dbuser = 'bacula',
	$dbpassword = 'bacula',
	$dbhost = 'localhost',
	$bweb_user = 'bacula',
	$bweb_passwd = 'bacula',
	$client = 'yes',
	$server = 'no',
    $schedules = ['FullDaily', 'FullWeekly', 'IncDaily', 'IncWeekly', 'DiffDaily', 'DiffWeekly'],
    $filesets = ['Catalog', 'FullSet']
) {
	if $server == 'yes' {
		include bacula::director
		include bacula::storage
		include bacula::filesets
		include bacula::schedules
    	include bacula::clients
	}

	if $client == 'yes' {
		include bacula::client
	}

	include bacula::console
}
