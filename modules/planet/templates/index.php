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
	if(is_dir($loc))
	{
		echo '<li><a href="'.$loc.'">'.$loc.'</a></li>';
	}
?>
</ul>
</body>
</html>
