<?php
$mysqli = new mysqli("localhost", "root", "", "vktransport");
if ($mysqli->connect_errno) {
    echo "Не удалось подключиться к MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$driver_id = 0;

    //Возвращает информацию о водителе по его id. Если id не найдет, вернет строку False
    //myserver/?id=1
    if (!empty($_GET['id']) && empty($_GET["GN"])) 
    { 
        $driver_id = $_GET['id'];

        if($driver_id <= 0)
        {
            echo "False <= 0";
        }
        else
        {
            $result = $mysqli->query("SELECT id FROM drivers");
                       
            if($result = $mysqli->query("SELECT * FROM Drivers WHERE id = $driver_id"))
            {                
                $row = $result->fetch_assoc();
                $Json = json_encode($row, JSON_UNESCAPED_UNICODE);
                print_r($Json);
            }
            else
            {
                echo "False";
            }
        }
    }

    //Создание нового рейса ВЫВОДИТ: id только что созданного рейса
    //myserver/?id=1&GN=12333&FN=5868969
    elseif (!empty($_GET["id"]) && !empty($_GET["GN"]) && !empty($_GET["FN"]))
    { 
        $GovermentNumber = $_GET['GN'];

        $FlightNumber = $_GET["FN"];
        //TODO: Добавить проверку на то существует ли такой id водителя
        $driver_id = $_GET['id'];

        //TODO: Добавить проверку на то, существуют ли эти данные в таблице. Если существуют то послать нахуй
        $sql = "INSERT INTO busflights (DriverId, GovermentNumber, FlightNumber) VALUES ($driver_id, $GovermentNumber, $FlightNumber)";

        if ($mysqli->query($sql)) 
        {
            $result = $mysqli->query("SELECT id FROM busflights WHERE id=LAST_INSERT_ID();");
            $row = array_values(mysqli_fetch_array($result));
            print_r($row[1]);
        } 
        else 
        {
            echo "Error: " . $sql . "<br>" . mysqli_error($DB_LINK);
        }
    }

    //Запрос информации о рейсе
    //myserver/?flight_id=13
    elseif (!empty($_GET["flight_id"]) && empty($_GET["payments"]) && empty($_GET["paymentType"]))
    {   
        $Flight_id = $_GET["flight_id"];

        $result = $mysqli->query("SELECT * FROM busflights WHERE id = $Flight_id");
        $row = $result->fetch_assoc();
        $Json = json_encode($row, JSON_UNESCAPED_UNICODE);
        print_r($Json);
    }
    //Запрос информации о всех выплатах на этот рейс
    //myserver/?flight_id=13&payments=all
    elseif (!empty($_GET["flight_id"]) && ($_GET["payments"] == 'all'))
    { 
        $Flight_id = $_GET["flight_id"];

        $result = $mysqli->query("SELECT * FROM payments WHERE flightId = $Flight_id");
        while($row = $result->fetch_assoc()){
            $Json = json_encode($row, JSON_UNESCAPED_UNICODE);
            print_r($Json );
            echo '<br>';
        }
    }
    //Запрос информации о конкретной выплате
    //myserver/?payments=payment&paymentId=15
    elseif (($_GET["payments"] == 'payment') && !empty($_GET['paymentId']))
    { 
        $payment_id = $_GET["paymentId"];

        $result = $mysqli->query("SELECT * FROM payments WHERE id = $payment_id");
        $row = $result->fetch_assoc();
        $Json = json_encode($row, JSON_UNESCAPED_UNICODE);
        print_r($Json);
    }

    //Саздать поле оплаты налом
    //myserver/?paymentType=Cash&ticketsCount=3&Cost=66&flight_id=13
    elseif (($_GET["paymentType"] == 'Cash') && !empty($_GET["ticketsCount"]) && !empty($_GET["Cost"]) && !empty($_GET["flight_id"]))
    {
        $ticketsCount = $_GET["ticketsCount"];
        $cost = $_GET["Cost"];
        $Flight_id = $_GET["flight_id"];
        
        $sql = "INSERT INTO `payments` (`id`, `date`, `paymentType`, `flightId`, `TicketsCount`, `Cost`) VALUES (NULL, CURRENT_TIME(), 'Cash', $Flight_id, $ticketsCount, $cost);";
        if ($mysqli->query($sql)) 
        {
            echo "True";
        } 
        else 
        {
            echo "False";
        }
    }
    //Сздать поле оплаты картой
    //myserver/?paymentType=BankCard&ticketsCount=5&Cost=77&flight_id=14&cardNumber=4444444444444444
    elseif (($_GET["paymentType"] == 'BankCard') && !empty($_GET["ticketsCount"]) && !empty($_GET["Cost"]) && !empty($_GET["flight_id"]) && !empty($_GET["cardNumber"]))
    {
        $ticketsCount = $_GET["ticketsCount"];
        $cost = $_GET["Cost"];
        $Flight_id = $_GET["flight_id"];
        $cardNumber = $_GET["cardNumber"];

        $sql1 = "INSERT INTO `payments` (`id`, `date`, `paymentType`, `flightId`, `TicketsCount`, `Cost`) VALUES (NULL, current_timestamp(), 'BankCard', $Flight_id, $ticketsCount, $cost);";
        $sql2 = "SELECT id FROM payments WHERE id=LAST_INSERT_ID()";
        
        if ($mysqli->query($sql1)) 
        {
            $result = $mysqli->query($sql2)->fetch_assoc();
            $id = $result['id'];
            $sql3 = "INSERT INTO `cards` (`cardNumber`, `paymentId`) VALUES ($cardNumber, $id)";
            $mysqli->query($sql3);

            echo "True";
        } 
        else 
        {
            echo "False";
        }
    }