#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"







MAIN_MENU() {
  # prompt services
  echo -e "\n1) corte\n2) cepillado\n3) baño"
  read SERVICE_ID_SELECTED

  if [[ ! "1 2 3" =~ $SERVICE_ID_SELECTED ]]
  then
    MAIN_MENU
  else
    # get customer info
    echo -e "\nInsert your phone number"
    read CUSTOMER_PHONE

    # Check Customer Phone
    PHONE=$($PSQL "SELECT phone from customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $PHONE ]]
    then 
        echo -e "\nWhat's your name?"
        read CUSTOMER_NAME
        
      #  echo -e "\nWhat time do you want to schedule?"
      #  read SERVICE_TIME

        #echo "$SERVICE_ID_SELECTED, $CUSTOMER_PHONE, $CUSTOMER_NAME, $SERVICE_TIME"
        
        # insert new customer
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    echo -e "\nWhat time do you want to schedule?"
    read SERVICE_TIME
    # Schedule appointment
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    echo "$SERVICE_ID_SELECTED, $CUSTOMER_PHONE, $CUSTOMER_NAME, $SERVICE_TIME"
    
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERe service_id=$SERVICE_ID_SELECTED;")
    echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
#   SERVICES_PROMPT=$($PSQL "SELECT * FROM services;")
#   declare -a SERVICES_ARR
#   while read SERVICE_ID BAR SERVICE_NAME;
#   do
#     SERVICES_ARR+=($SERVICE_ID)
#     echo "$SERVICE_ID) $SERVICE_NAME"  
#   #  COUNT=$SERVICE_ID 
#   done < <(echo "$SERVICES_PROMPT") #process substitution
#  # AUX=$((COUNT+1))
# #  echo "$AUX) EXIT"

  # pick service
#   read PICK_SERVICE
#   if [[ ! ${SERVICE_ARR[@]} =~ $PICK_SERVICE ]]
#   then
#     MAIN_MENU
#   fi
 }


MAIN_MENU
