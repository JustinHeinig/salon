#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -c"
#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -A -c"

while true
do
  echo "1) 1"
  echo "2) 2"
  echo "3) 3"

  read SERVICE_ID_SELECTED

  SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;" 2>/dev/null)

  if [[ -n "$SERVICE_EXISTS" ]]; then
    break
  fi
done

echo "What is your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME_DB=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';" | xargs)

if [[ -z "$CUSTOMER_NAME_DB" ]]; then
  echo "What is your name?"
  read CUSTOMER_NAME
  $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');" > /dev/null
else
  CUSTOMER_NAME="$CUSTOMER_NAME_DB"
fi

echo "What time would you like your service?"
read SERVICE_TIME


CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';" | xargs)
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;" | xargs)

$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');" > /dev/null

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
