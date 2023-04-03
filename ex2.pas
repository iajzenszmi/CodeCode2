const
    N = 20;

var
    arr: array[1..N] of integer;
    i, m, qty: byte;

begin
    write('Amount of items: ');
    readln(m);
    write('Items: ',m);
    for i := 1 to m do
        read(arr[i]);
    readln;

    qty := 0;
    i := 2;
    while i < m do
        if (arr[i] > arr[i-1]) and 
           (arr[i] > arr[i+1]) then 
        begin
            qty := qty + 1;
            i := i + 2
        end
        else
            i := i + 1;

    write('Number of items that are larger than neighbors: ');
    writeln(qty);
end.
