<?php
    /*
     *
     * @ Multiple File upload script.
     *
     * @ Can do any number of file uploads
     * @ Just set the variables below and away you go
	 * @ Author: Di Muzio/Lutz
     *
     * @ 2013 photografix.ch GmbH
     *
     */

    error_reporting(E_ALL);
	
	/*
	email html message var, headers and helper vars to build the links to download and store the files
	*/
	
	$allowedExts = array("csv", "xls", "xlsx", "txt","gif", "jpeg", "jpg", "png");
	$comma_separated_allowedExts = implode(",", $allowedExts);
	$to = $_POST['anfrageFormular_emailkonto'];
	$subject = $_POST['anfrageFormular_subject'];
	$shopUrl = $_POST['shopURL'];
	$prefixFile = $_POST['firma'];
	$messageTextBoxForm = '';
	
	$headers = "From: " . strip_tags($_POST['anfrageFormular_emailkonto']) . "\r\n";
	$headers .= "Reply-To: ". strip_tags($_POST['anfrageFormular_emailkonto']) . "\r\n";
	$headers .= "MIME-Version: 1.0\r\n";
	$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
	
	$message = '<html><body>';
	$message .= '<h1>'.$subject.'</h1>';
	$message .= 'Salutation: '.$_POST['anrede'].'<br>';
	$message .= 'Lastname, Firstname: '.$_POST['nachname'].' '.$_POST['vorname']. '<br>';
	$message .= 'Company: '.$_POST['firma'].'<br><br>';
	$message .= 'Email: '.$_POST['email'].'<br>';
	
	if(isset($_POST['nachricht'])) $message .= 'Nachricht/Files: '.$_POST['nachricht'].'<br>';
	
	$err = 'Meldungen... ';
    /*** the upload directory ***/
	$upload_dir = '/home/all4wawi/www/wawishop_all4/mediafiles/ankaufsanfrage';
	$link_urlDir = '/mediafiles/ankaufsanfrage';
    /*** numver of files to upload ***/
    $max_num_uploads = $_POST['max_num_uploads'];

    /*** maximum filesize allowed in bytes ***/
    $max_file_size  = $_POST['max_file_size'];
 
    /*** the maximum filesize from php.ini ***/
    $ini_max = str_replace('M', '', ini_get('upload_max_filesize'));
    $upload_max = $ini_max * 1024;

    /*** a message for users ***/
    $msg = 'Please select files for uploading';
    $responseTextAnfrageFormular = '';
    /*** an array to hold messages ***/
    $messages = array();
	$linksToFiles = array();
	$fileType = array();
	$customValidationFileSizeTypeErrors = array();
	$booleanCheckIfMailOk = true;
	
	/*DEBUG START*/
	//echo count($_FILES['file']['tmp_name']);
	//exit;
	/*DEBUG END*/
	
    /*** check if a file has been submitted ***/
    if(isset($_FILES['file']['tmp_name']))
    {
        /** loop through the array of files ***/
        for($i=0; $i < count($_FILES['file']['tmp_name']);$i++)
        {
            // check if he's trying to upload the max number of files allowed within the current index count of the loop
			if($i <= $max_num_uploads)
			{
			
			$temp = explode(".", $_FILES["file"]["name"][$i]);
			$extension = strtolower(end($temp));
			
			// DEBUG START $responseTextAnfrageFormular .= $_FILES["file"]["name"][$i]. ' is of type ' .$_FILES["file"]["type"][$i].' and has the extension '.$extension;
			
            if(!is_uploaded_file($_FILES['file']['tmp_name'][$i]))
            {
                $messages[] = 'No file uploaded';
            }
			
			elseif(($_FILES["file"]["type"][$i] != "image/gif" || $_FILES["file"]["type"][$i] == "image/jpeg" || $_FILES["file"]["type"][$i] != "image/jpg" || $_FILES["file"]["type"][$i] != "image/pjpeg" || $_FILES["file"]["type"][$i] != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" || $_FILES["file"]["type"][$i] != "application/vnd.ms-excel" || $_FILES["file"]["type"][$i] != "text/plain" || $_FILES["file"]["type"][$i] != "image/x-png" || $_FILES["file"]["type"][$i] != "image/png") && !in_array($extension, $allowedExts)) {
					// DEBUG START $responseTextAnfrageFormular .= ' ..and therefore not valid... ';
					$customValidationFileSizeTypeErrors[] = $_FILES["file"]["name"][$i] . '-> type not allowed';
					continue;
			}
			
			
            /*** check if the file is less then the max php.ini size. too risky to rely on that ***/
            /*
			elseif($_FILES['file']['size'][$i] > $upload_max)
            {
                $messages[] = "File size exceeds $upload_max php.ini limit";
				$responseTextAnfrageFormular .= "File size exceeds $upload_max php.ini limit";
            }
			*/
			
            // check the file is less than the maximum file size set manually on the beginning of the page
            elseif($_FILES['file']['size'][$i] > $max_file_size)
            {
                $messages[] = "File size exceeds $max_file_size limit";
				// DEBUG $responseTextAnfrageFormular .= "File size exceeds $max_file_size limit set manually";
				$customValidationFileSizeTypeErrors[] = $_FILES["file"]["name"][$i] . '-> to big';
				continue;
            }
			
			
            else
            {
                // copy/move the file to the specified dir 
				if(move_uploaded_file($_FILES['file']['tmp_name'][$i],
				$upload_dir.'/' . date("Y-m-d").'_'. time().'_'.$prefixFile.'_'.$_FILES["file"]["name"][$i]))
                {
                    /*** give praise and thanks to the php gods ***/
					$fileType[] = $_FILES['file']['type'][$i].' type';
                    $messages[] = $_FILES['file']['name'][$i].' uploaded';
					$linksToFiles[] = '<a href='.$shopUrl.'/'.$link_urlDir.'/'. date("Y-m-d").'_'. time().'_'.$prefixFile.'_'.$_FILES["file"]["name"][$i].'>'.$shopUrl.'/'.$link_urlDir.'/'. date("Y-m-d").'_'. time().'_'.$prefixFile.'_'.$_FILES["file"]["name"][$i].'</a><br>';
                }
				
                else
                {
                    /*** an error message ***/
                    $messages[] = 'Uploading '.$_FILES['file']['name'][$i].' Failed';
                }
            }
          }
		}
		
			
    }
	
	 if(sizeof($messages) != 0)
    {
        foreach($messages as $err)
        {
            //echo $err.'<br />';
        }
    }
	
	for($ii=0; $ii < count($linksToFiles);$ii++) {
			$message .= $linksToFiles[$ii];
	}
	
	$message .= '</body></html>';
	$responseTextAnfrageFormular .= $_POST['responseText'];
	
	mail($to, $subject, $message, $headers);
	// DEBUG echo count($customValidationFileSizeTypeErrors);
	/*
	foreach($customValidationFileSizeTypeErrors as $errorValid)
        {
            $responseTextAnfrageFormular .= 'Validation error: '.$errorValid.'<br />';
    }
	*/	
	//$max_num_uploads = $max_num_uploads - 1;
	if (count($_FILES['file']['tmp_name']) > $max_num_uploads || count($customValidationFileSizeTypeErrors) > 0 ) {	
	$responseTextAnfrageFormular .= '<br /><font color=red>Unfortunately, there has been errors with the amount of files, the file types or file size of your files you\'ve tried to upload to the server.</font>';
	}
    print $responseTextAnfrageFormular;
?>