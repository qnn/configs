<?php
$jekyll = '/usr/local/bin/jekyll';

$base = realpath('../');

if (isset($_POST['payload'])) {
	$payload = json_decode($_POST['payload'], true);
	
	$head_commit = $payload['head_commit'];
	
	$added = $head_commit['added'];
	$removed = $head_commit['removed'];
	$modified = $head_commit['modified'];
	
	$all = array_unique(array_merge($added, $removed, $modified));
	
	$all_configs = array();
	
	$commands = array();
	
	foreach ($all as $A) {
		if (preg_match('#^configs/(.*)/_config\.yml$#', $A, $matches)) {
			array_push($commands, $jekyll.' build --source "'.$base.'/source" --destination "'.$base.'/sites/'.$matches[1].'" --config "'.$base.'/source/_config.yml","'.$base.'/configs/'.$matches[1].'/_config.yml"');
		}
	}
	
	if (count($commands) > 0) {
		$buffer = '['.date('Y-m-d H:i:s O').'] Start ->'."\n";
		array_unshift($commands, 'git pull origin master');
		array_unshift($commands, $jekyll.' --version');
		
		foreach ($commands as $command) {
			$buffer .= '['.date('Y-m-d H:i:s O').'] $ '.$command."\n";
			$buffer .= shell_exec($command);
			$buffer .= "\n";
		}
		
		$buffer .= '['.date('Y-m-d H:i:s O').'] <- End'."\n\n";
		
		file_put_contents('jekyll-build-'.date('Y-m').'.log', $buffer, FILE_APPEND);
	}
}
