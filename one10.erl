%%generate an erlang program to print the numbers 1 to 10. Correct all syntax errors. Correct all logic errors.

%% Print the numbers 1 to 10
main()
     Print_1_to_10().

Print_1_to_10() ->
    %% Print 1 to 10
    print_numbers(1, 10).

%% Print numbers from Start to End
print_numbers(1,10) when Start <= End ->
    io:fwrite("~p~n", [Start]),
    print_numbers(Start + 1, End);
print_numbers(1,10) ->
    ok.
