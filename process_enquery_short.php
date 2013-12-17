<?php
    
	// Falls eine Zeile der Nachricht mehr als 70 Zeichen enthälten könnte,
	// sollte wordwrap() benutzt werden
	//$nachricht = wordwrap($nachricht, 70);
	error_reporting(E_ALL);
	$to = $_POST['anfrageFormular_emailkonto'];
	$subject = $_POST['anfrageFormular_subject'];
	$messageTextBoxForm = '';
	
	$headers = "From: " . strip_tags($_POST['anfrageFormular_emailkonto']) . "\r\n";
	$headers .= "Reply-To: ". strip_tags($_POST['anfrageFormular_emailkonto']) . "\r\n";
	$headers .= "MIME-Version: 1.0\r\n";
	$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
	
	$message = '<html><body>';
	$message .= '<h1>'.$subject.'</h1>';
	$message .= 'Salutation: '.$_POST['cAnrede'].'<br>';
	$message .= 'Lastname: '.$_POST['lastname'].'<br>';
	$message .= 'Company: '.$_POST['firma'].'<br><br>';
	$message .= 'Email: '.$_POST['email'].'<br>';
	$message .= 'Nachricht: '.$_POST['message'].'<br>';

	$message .= '</body></html>';
	$responseTextAnfrageFormular = $_POST['responseText'];
	mail($to, $subject, $message, $headers);
    print $responseTextAnfrageFormular;
?>