program LiftSimulation;

const
  MAX_FLOORS = 100;

type
  RequestArray = array [1..MAX_FLOORS] of Integer;

var
  N, C, P, currentPosition, currentPassengers: Integer;
  passengerCount: array [1..MAX_FLOORS] of Integer;
  requests: RequestArray;
  liftStatus: String;

procedure InitializeVariables();
var
  i: Integer;
begin
  currentPosition := 0;
  currentPassengers := 0;
  liftStatus := 'idle';
  for i := 1 to N do
    passengerCount[i] := 0;
end;

function FindNextRequestFloor(requests: RequestArray; currentPosition: Integer): Integer;
var
  i: Integer;
begin
  for i := currentPosition + 1 to N do
    if requests[i] > 0 then
      Exit(i);
  for i := currentPosition - 1 downto 1 do
    if requests[i] > 0 then
      Exit(i);
  Exit(0);
end;

procedure PrintResults(passengerCount: array of Integer; currentPosition: Integer);
var
  i: Integer;
begin
  for i := 1 to N do
    WriteLn('Floor ', i, ': ', passengerCount[i], ' passengers');
  WriteLn('Lift stopped at floor ', currentPosition);
end;
var
	i: Integer;
begin
  Write('Enter the number of floors: ');
  ReadLn(N);
  Write('Enter the lift capacity: ');
  ReadLn(C);
  Write('Enter the number of passengers: ');
  ReadLn(P);
  for i := 1 to N do
  begin
    Write('Enter the number of passenger requests on floor ', i, ': ');
    ReadLn(requests[i]);
  end;
  
  InitializeVariables();
  
  while currentPassengers < P do
  begin
    if liftStatus = 'idle' then
    begin
      currentPosition := FindNextRequestFloor(requests, currentPosition);
      if currentPosition > 0 then
        liftStatus := 'serving'
      else
        break;
    end
    else if liftStatus = 'serving' then
    begin
      requests[currentPosition] := requests[currentPosition] - 1;
      currentPassengers := currentPassengers + 1;
      passengerCount[currentPosition] := passengerCount[currentPosition] + 1;
      if currentPassengers = C then
        liftStatus := 'dropping';
    end;
    
    if liftStatus = 'dropping' then
    begin
      currentPosition := 0;
      liftStatus := 'idle';
      currentPassengers := 0;
    end;
  end;
  
  PrintResults(passengerCount, currentPosition);
  
end.

