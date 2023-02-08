elevator simulation

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <cmath>
#include <queue>
#include <stack>
#include <map>
#include <set>
#include <unordered_map>
#include <unordered_set>
#include <limits>
#include <cassert>
#include <fstream>
#include <array>

using namespace std;

#define endl '\n'


int main() {
    std::ios_base::sync_with_stdio(0);
    cin.tie(0);
    cout.precision(10);

    int n, m;
    cin >> n >> m;

    vector<int> v(n);

    for (size_t i = 0; i < n; ++i)
        cin >> v[i];

    int result = 0;

    for (size_t i = 0; i < n; ++i) {
        int current = v[i];> elevator simulation
> 
> #include <iostream>
> #include <string>
> #include <vector>
> #include <algorithm>
> #include <cmath>
> #include <queue>
> #include <stack>
> #include <map>
> #include <set>
> #include <unordered_map>
> #include <unordered_set>
> #include <limits>
> #include <cassert>
> #include <fstream>
> #include <array>
> 
> using namespace std;
> 
> #define endl '\n'
> 
> 
> int main() {
>     std::ios_base::sync_with_stdio(0);
>     cin.tie(0);
>     cout.precision(10);
> 
>     int n, m;
>     cin >> n >> m;
> 
>     vector<int> v(n);
> 
>     for (size_t i = 0; i < n; ++i)
>         cin >> v[i];
> 
>     int result = 0;
> 
>     for (size_t i = 0; i < n; ++i) {
>         int current = v[i];
>         int next = v[(i + 1) % n];
> 
>         if (current > next)
>             result += m - current + next;
>         else
>             result += next - current;
>     }
> 
>     cout << result << endl;
> 
>     return 0;
> }


        int next = v[(i + 1) % n];

        if (current > next)
            result += m - current + next;
        else
            result += next - current;
    }

    cout << result << endl;

    return 0;
}
