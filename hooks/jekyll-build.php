<?php
$jekyll = '/usr/local/bin/jekyll';

$git = '/usr/bin/git';

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
			array_push($commands, $jekyll.' build --source "'.$base.'/source" --destination "'.$base.'/sites/'.$matches[1].'" --config "'.$base.'/source/_config.yml","'.$base.'/configs/'.$matches[1].'/_config.yml" 2>&1');
		}
	}
	
	if (count($commands) > 0) {
		$buffer = '['.date('Y-m-d H:i:s O').'] Start ->'."\n\n";
		array_unshift($commands, $git.' pull origin master 2>&1');
		array_unshift($commands, $jekyll.' --version 2>&1');
		
		foreach ($commands as $command) {
			$buffer .= '['.date('Y-m-d H:i:s O').'] $ '.$command."\n";
			$buffer .= shell_exec($command);
			$buffer .= "\n";
		}
		
		$buffer .= '['.date('Y-m-d H:i:s O').'] <- End'."\n\n";
		
		file_put_contents('jekyll-build-'.date('Y-m').'.log', $buffer, FILE_APPEND);
		
		shell_exec($git.' add --all '.$base.'/hooks/*.log 2>&1');
		shell_exec($git.' commit --author "caiguanhao <caiguanhao@gmail.com>" -m "Automatically update jekyll build log files. [WEB HOOKS]" 2>&1');
		shell_exec($git.' push origin master 2>&1');
	}
}
