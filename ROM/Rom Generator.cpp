#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <cstdio>
#include <string>
#include <cstring>
#include <iomanip>
#include <algorithm>
#include <vector>
#include <cmath>
#include <cstdlib>
#include <sstream>
#include <fstream>
#include <stdio.h>
#include <set>
#include <map>
#include <utility>
#include <numeric>
#include <queue>
#include <bitset>
#include <stack>
#include <unordered_set>
#include <cctype>
#include <unordered_map>
using namespace std;

#define all(v) (v).begin(), (v).end()
#define SRT(v) sort(all(v))
#define rall(v) (v).rbegin(), (v).rend()
#define rSRT(v) sort(rall(v))
#define sz(a) int((a).size())
#define PB push_back
#define trav(c, i) for(typeof((c).begin()i=(c).begin();i!=(c).end();i++)
#define mem(a, b) memset(a, b, sizeof(a))
#define MP make_pair
#define EPS 1e-9
#define Mod (ll)1e9 + 7
#define oo 1e9
#define OO 1e14 * 1LL
#define PI 3.141592653589793
#define F first
#define S second
#define pw(x) (x) * (x)

typedef stringstream ss;
typedef long long ll;
typedef vector<int> vi;
typedef vector<string> vs;
typedef vector<long long> vll;
typedef vector<bool> vb;
typedef vector<double> vd;
typedef vector<vi> vvi;
typedef pair<int, int> ii;
typedef pair<int, ll> il;
typedef vector<vector<ii>> vvii;
typedef vector<vector<il>> vvil;
string str, cw, mySignal;
map<string, string> myMap;
int main()
{
	// Two Operand
	myMap["ADD"] = "0000000000000000001000000";
	myMap["AND"] = "0000000000000000100000000";
	myMap["OR"] = "0000000000000000101000000";
	myMap["XNOR"] = "0000000000000000110000000";
	myMap["ADDC"] = "0000000000000000001000001";
	myMap["SUB"] = "0000000000000000010000000";
	myMap["SUBC"] = "0000000000000000010000001";

	// One Operand
	myMap["INCA"] = "0000000000000000000000010";
	myMap["DECA"] = "0000000000000000011000000";
	myMap["INV"] = "0000000000000000111000000";
	myMap["CLR"] = "0000000000000001111000000";
	myMap["ROL"] = "0000000000000001101000000";
	myMap["ROR"] = "0000000000000001001000000";
	myMap["LSL"] = "0000000000000001100000000";
	myMap["LSR"] = "0000000000000001000000000";
	myMap["RRC"] = "0000000000000001010000001";
	myMap["RLC"] = "0000000000000001110000001";
	myMap["ASR"] = "0000000000000001011000000";
	
	

	myMap["PCOUTB"] = "0000010000000000000000000";
	myMap["IRIN"] =   "0000000010100000000000000";
	myMap["MARIN"] = "0000000000000100000000000";
	myMap["MDROUTA"] = "0111000000000000000000000";
	myMap["PCIN"] = "0000000010000000000000000";
	myMap["PCOUTA"] = "0100000000000000000000000";
	myMap["RDISTIN"] = "0000000001000000000000000";
	myMap["RDISTOUTA"] = "0010000000000000000000000";
	myMap["RDISTOUTB"] = "0000001000000000000000000";
	myMap["READ"] = "0000000000000000000000100";
	myMap["RSRCIN"] = "0000000000100000000000000";
	myMap["RSRCOUTA"] = "0001000000000000000000000";
	myMap["RSRCOUTB"] = "0000000100000000000000000";
	myMap["TRANSFERA"] = "0000000000000000000000000";
	myMap["WMFC"] = "0000000000000000000100000";
	myMap["XIN"] = "0000000000001000000000000";
	myMap["YIN"] = "0000000000010000000000000";
	myMap["XOUTA"] = "0101000000000000000000000";
	myMap["XOUTB"] = "0000010100000000000000000";
	myMap["YOUTA"] = "0110000000000000000000000";
	myMap["YOUTB"] = "0000011000000000000000000";
	myMap["WRITE"] = "0000000000000000000001000";
	myMap["MDRIN"] = "0000000000000010000000000";


	ios::sync_with_stdio(false);
	cin.tie(0);
	cout.tie(0);
	freopen("input.txt", "r", stdin);
	freopen("output.txt", "w", stdout);
	int cnt = 1;
	cw.resize(25);
	while (getline(cin, str)) {
		if (str == "") {
			cout << "0000000000000000000000000" << endl;
			getline(cin, str);
			if (str == "")
				break;
		}
		if (str[0] == '#') continue;
		for (int i = 0; i < 25; ++i) cw[i] = '0';
		for (int i = 0; i < sz(str); ++i) if (islower(str[i]))
			str[i] = toupper(str[i]);
		stringstream ss(str);
		while (ss >> mySignal) {
			mySignal = myMap[mySignal];
			for (int i = 0; i < 25; ++i)
				if (cw[i] == '0' && mySignal[i] == '1')
					cw[i] = '1';
		}
		cout << cw << endl;
		// for (int i = 0; i < 4; ++i) cout << cw[i];
		// cout << " ";
		// for (int i = 4; i < 8; ++i) cout << cw[i];
		// cout << " ";
		// for (int i = 8; i < 11; ++i) cout << cw[i];
		// cout << " ";
		// for (int i = 11; i < 13; ++i) cout << cw[i];
		// cout << " ";
		// for (int i = 13; i < 15; ++i) cout << cw[i];
		// cout << " ";
		// for (int i = 15; i < 19; ++i) cout << cw[i];
		// cout << " ";
		// cout << cw[19] << " " << cw[20] << " " << cw[21] << cw[22] << " " << cw[23] <<" "<< cw[24] << endl;
	}
	return 0;
}
