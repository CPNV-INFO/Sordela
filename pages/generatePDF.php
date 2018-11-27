<?php
	require('fpdf.php'); //Used to print pin code
	
	$test = new FPDF('L','mm',array(100,24));
	$test->AddPage();
	$test->SetFont('Arial','B',16);
	$test->Cell(40,10,'Hello World !');
	$test->Output();
	
?>