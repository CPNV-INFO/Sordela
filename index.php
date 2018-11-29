<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sordela</title>
    <link rel="stylesheet" href="node_modules/bootstrap/dist/css/bootstrap.css">
    <script src="node_modules/jquery/dist/jquery.js"></script>
    <script src="node_modules/bootstrap/dist/js/bootstrap.js"></script>
    <script src="js/code.js"></script>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<?php
error_reporting(E_ERROR | E_PARSE);
require_once("const.php"); // some useful values

require_once("model/database.php"); // for db connection
$pdo = dbConnection();

$page = "home";
extract($_POST);

if (isset($printpin)) // Used to generate a PDF file using FPDF and FPDF_JS to print the pin code of the end-user on a Brother P-Touch printer when clicking on the button.
{
	ob_clean(); //If i do not do this, FPDF cannot output datas
	
	require('fpdf_js.php');

	class PDF_AutoPrint extends PDF_JavaScript // From : http://www.fpdf.org/en/script/script36.php
	{
		function AutoPrint($printer='')
		{
			// Open the print dialog
			if($printer)
			{
				$printer = str_replace('\\', '\\\\', $printer);
				$script = "var pp = getPrintParams();";
				$script .= "pp.interactive = pp.constants.interactionLevel.full;";
				$script .= "pp.printerName = '$printer'";
				$script .= "print(pp);";
			}
			else
				$script = 'print(true);';
			$this->IncludeJS($script);
		}
	}

	$pinCode = new PDF_AutoPrint('L','mm',array(46,24));
	$pinCode->AddPage();
	$pinCode->SetFont('Arial','B',32); 
	$pinCode->SetMargins(0,0,0);	
	$pinCode->SetAutoPageBreak(0);
	$pinCode->Cell(0,6,$printpin);
	$pinCode->AutoPrint();
	$pinCode->Output('pincode.pdf','I');
}

if (isset($sendpin)) // Used to send the pin code of the end-user to an adress mail who will send it in a SMS to the end-user phone number.

{	
	//Return the contact field of the selected user from the DB.
	$contact = $pdo->prepare('select contact from persons where PIN='.$sendpin);
	$contact->execute();
	$persons = $contact->fetchAll(PDO::FETCH_ASSOC);
	
	
	$personContact = str_replace(' ','',$persons[0]['contact']);
	$to = $personContact."@sms.admin.ch";
	//Checking if the contact info is a valid number, or a valid mail, and send it by mail with the pin number of the selected user.
	if (ctype_digit($personContact))
	{
		mail($to,"Code PIN CPNV",$sendpin); //Send the code to <number>@sms.admin.ch, who will send the SMS with the PIN code.
		$message = "Code PIN envoyé avec succès par SMS.";
	}
	else if (filter_var($personContact, FILTER_VALIDATE_EMAIL))
	{
		mail($personContact,"Code PIN CPNV",$sendpin); //Send the code directly to the mail of the user.
		$message = "Code PIN envoyé avec succès par mail.";	
	}
	else
	{
		$message = "Adresse mail/Numéro de téléphone non valide.";
	}
	
	//Used to stay on the same page, as admin.
	$pin=9999;
}

if (isset($diploma)) // request to display a diploma
{
    // get person info
    $stmt = $pdo->prepare('select nickname, cursus as cid, c.name as cursusname from persons inner join cursus c on persons.cursus = c.id where persons.id = :id');
    $stmt->execute(['id' => $pid]);
    extract($stmt->fetch(PDO::FETCH_ASSOC)); // $nickname, $cid, $cursusname

    // verify that all challenges have been responded to
    // Number of challenges for selected cursus
    $stmt = $pdo->prepare('select count(*) as nbChallenges from cursus_challenges where cursus_id = :cid');
    $stmt->execute(['cid' => $cid]);
    extract($stmt->fetch(PDO::FETCH_ASSOC)); // $nbChallenges

    // Number of grades
    $stmt = $pdo->prepare('select count(*) as nbGrades from grades where person_id = :pid');
    $stmt->execute(['pid' => $pid]);
    extract($stmt->fetch(PDO::FETCH_ASSOC)); // $nbGrades

    if ($nbGrades == $nbChallenges)
    {
        // get average
        $stmt = $pdo->prepare('select round(avg(gradeValue),1) as average from grades where person_id = :id;');
        $stmt->execute(['id' => $pid]);
        extract($stmt->fetch(PDO::FETCH_ASSOC));

        if ($average >= 4)
        {
            $mention = $mentions[round($average*2)-8];
            $cursus = 99; // bad trick to display diploma
        }
        else
        {
            $message = "Moyenne insuffisante";
            $cursus = 9; // bad trick to redirect to admin
			$stmt = $pdo->prepare('select id, nickname, contact, cursus, pin from persons');
			$stmt->execute();
			$persons = $stmt->fetchAll(PDO::FETCH_ASSOC);
        }
    }
    else
    {
        $message = "Il manque des notes... ($nbGrades / $nbChallenges)";
        $cursus = 9; // bad trick to redirect to admin
		$stmt = $pdo->prepare('select id, nickname, contact, cursus, pin from persons');
        $stmt->execute();
        $persons = $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

}

// Someone submits a response
if (isset($challengeSubmit))
{ // verify response
    $stmt = $pdo->prepare('select responseType, response from questions where questions.id = :questionid');
    $stmt->execute(['questionid' => $questionid]);
    extract($stmt->fetch(PDO::FETCH_ASSOC));
    if ($responseType == 2) // grade direct input
    {
        if ($challengeResponse >= 1 && $challengeResponse <= 6)
            $grade = intVal($challengeResponse);
        else
            $message = "C'est cela...oui...$grade";
    }
    else
    {
        similar_text(strtoupper($response), strtoupper($challengeResponse), $res);
        $grade = round($res * 1.2 / 10); // "double grade" to pick message first. 100% -> 12
        $message = $evalmessages[$grade];
        $grade /= 2;
    }
    // insert grade or update it if exists
    $stmt = $pdo->prepare('insert into grades (challenge_id, person_id, gradeValue) values (:challengeid, (select id from persons where pin = :pin), :grade) on duplicate key update gradeValue=:grade2');
    $stmt->execute(['challengeid' => $challengeid, 'pin' => $pin, 'grade' => $grade, 'grade2' => $grade]);

}

// Handle insert
if (isset($newperson))
{
    $stmt = $pdo->prepare('insert into persons (nickname, PIN, cursus, contact) values (:name,0,:cursus,:contact)');
    try {
        $stmt->execute(["name" => $newnickname,"cursus" => $newcursus,"contact" => $newcontact]);
        do {
            $newpin = rand(1000,9999);
            $stmt = $pdo->prepare('update persons set pin = :pin where id = :id');
            try
            {
                $stmt->execute(['pin' => rand(1000,9999), 'id' => $pdo->lastInsertId()]);
                $success = true;
            } catch (Exception $e) {
                $success = false;
            }
        } while (!$success);
    } catch (Exception $e) {
        $message = "Ce nom est déjà pris";
    }
    $pin = 9999; // redirect to admin
}

// Get person info
if (isset($pin))
{
    if ($pin == 9999)
    {
        $cursus = 9;

        // Get all users
        $stmt = $pdo->prepare('select id, nickname, contact, cursus, pin from persons');
        $stmt->execute();
        $persons = $stmt->fetchAll(PDO::FETCH_ASSOC);
    } else // participant: search person in db
        if ($pin == 9998)
        {
            $cursus = 98;

            // Get all questions
            $stmt = $pdo->prepare('select course, question, response from challenges inner join questions on challenge_id = challenges.id');
            $stmt->execute();
            $questions = $stmt->fetchAll(PDO::FETCH_ASSOC);
        } else // participant: search person in db
    {
        $stmt = $pdo->prepare('select id, nickname, cursus from persons where PIN = :pin');
        $stmt->execute(['pin' => $pin]);
        if ($stmt->rowCount() > 0)
        {
            extract($stmt->fetch(PDO::FETCH_ASSOC));
            $name = "$firstname $lastname";

            // Get average
            $stmt = $pdo->prepare('select count(*) as nbChallenges from challenges');
            $stmt->execute();
            extract($stmt->fetch(PDO::FETCH_ASSOC)); // $nbChallenges

            $stmt = $pdo->prepare('select sum(gradeValue) as totalPoints from grades where person_id = :id;');
            $stmt->execute(['id' => $id]);
            extract($stmt->fetch(PDO::FETCH_ASSOC)); // totalPoints

            $average = round($totalPoints/$nbChallenges,1);

            // Get the questions
            $stmt = $pdo->prepare('select id, course from challenges');
            $stmt->execute();
            while ($chal = $stmt->fetch(PDO::FETCH_ASSOC))
            {
                $id = $chal['id'];

                $stmt2 = $pdo->prepare('select id, question from questions where challenge_id = :id order by rank');
                $stmt2->execute(['id' => $id]);
                $qs = $stmt2->fetchAll(PDO::FETCH_ASSOC);

                $stmt3 = $pdo->prepare('select gradeValue from grades inner join persons on person_id = persons.id where challenge_id = :cid and pin = :pin');
                $stmt3->execute(['cid' => $id, 'pin' => $pin]);
                unset($gradeValue);
                extract($stmt3->fetch(PDO::FETCH_ASSOC));

                $chals[$id]['qid'] = $qs[$pin % $stmt2->rowCount()]['id'];
                $chals[$id]['question'] = $qs[$pin % $stmt2->rowCount()]['question'];
                $chals[$id]['text'] = $chal['course'];
                $chals[$id]['grade'] = $gradeValue;
            }
        }
    }
}

switch ($cursus)
{
    case 1:
        $page = "cfc";
        break;
    case 2:
        $page = "mpt";
        break;
    case 3:
        $page = "fpa";
        break;
    case 4:
        $page = "techdev";
        break;
    case 9:
        $page = "admin";
        break;
    case 98:
        $page = "admin2";
        break;
    case 99:
        $page = "diploma";
        break;
}
include_once "pages/$page.html";
?>
</body>
</html>