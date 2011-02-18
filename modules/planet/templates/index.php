<html>
<body>
<h1>Planet Mageia</h1>
<h3>Please choose one of the following locales:</h3>
<ul>
<?php
function displayloc($path = ''){
	return array_slice(scandir($path), 2);
}

foreach(displayloc('.') as $loc)
	if(is_dir($loc) && $loc != "test" && $loc != "test-2")
	{
		echo '<li><a href="'.$loc.'">'.$loc.'</a></li>';
	}
?>
</ul>
<h3>How to be listed in Planet Mageia:</h3>
<ul>
<li>just candidate by sending us a RSS feed talking about Mageia in only one locale.</li>
</ul>
</body>
</html>
