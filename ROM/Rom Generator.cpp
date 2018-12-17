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

	myMap["ADD"]		= "000000000000000000100000";
	myMap["DECA"]		= "000000000000000001100000";
	myMap["INCA"]		= "000000000000000000000001";
	myMap["MARIN"]		= "000000000000010000000000";
	myMap["MDROUTA"]	= "011100000000000000000000";
	myMap["PCIN"]		= "000000001000000000000000";
	myMap["PCOUTA"]		= "010000000000000000000000";
	myMap["RDISTIN"]	= "000000000100000000000000";
	myMap["RDISTOUTA"]	= "001000000000000000000000";
	myMap["RDISTOUTB"]  = "000000100000000000000000";
	myMap["READ"]		= "000000000000000000000010";
	myMap["RSRCIN"]		= "000000000010000000000000";
	myMap["RSRCOUTA"]   = "000100000000000000000000";
	myMap["RSRCOUTB"]   = "000000010000000000000000";
	myMap["TRANSFERA"]  = "000000000000000000000000";
	myMap["WMFC"]		= "000000000000000000010000";
	myMap["XIN"]		= "000000000000100000000000";
	myMap["YIN"]		= "000000000001000000000000";
	myMap["AND"]		= "000000000000000010000000";
	myMap["OR"]			= "000000000000000010100000";
	myMap["XNOR"]		= "000000000000000011000000";
	myMap["NOT"]		= "000000000000000011100000";
	myMap["ADDC"]		= "000000000000000000100001";
	myMap["CLEAR"]		= "000000000000000001100001";
	myMap["ROL"]		= "000000000000000110100000";
	myMap["ROR"]		= "000000000000000100100000";
	myMap["SHL"]		= "000000000000000110000000";
	myMap["SHR"]		= "000000000000000100000000";
	myMap["RORC"]		= "000000000000000101000000";
	myMap["ROLC"]		= "000000000000000111000000";
	myMap["ASHR"]		= "000000000000000101100000";

	ios::sync_with_stdio(false);
	cin.tie(0);
	cout.tie(0);
	freopen("input.txt", "r", stdin);
	freopen("output.txt", "w", stdout);
	int cnt = 1;
	cw.resize(24);
	while (getline(cin, str)){
		if (str == ""){
			cout << endl;
			getline(cin, str);
			if (str == "")
				break;
		}
		for (int i = 0; i < 24; ++i) cw[i] = '0';
		for (int i = 0; i < sz(str); ++i) if (islower(str[i]))
			str[i] = toupper(str[i]);
		stringstream ss(str);
		while (ss >> mySignal){
			mySignal = myMap[mySignal];
			for (int i = 0; i < 24; ++i)
				if (cw[i] == '0' && mySignal[i] == '1')
					cw[i] = '1';
		}
		for (int i = 0; i < 4; ++i) cout << cw[i];
		cout << " ";
		for (int i = 4; i < 8; ++i) cout << cw[i];
		cout << " ";
		for (int i = 8; i < 11; ++i) cout << cw[i];
		cout << " ";
		for (int i = 11; i < 13; ++i) cout << cw[i];
		cout << " ";
		for (int i = 13; i < 15; ++i) cout << cw[i];
		cout << " ";
		for (int i = 15; i < 19; ++i) cout << cw[i];
		cout << " ";
		cout << cw[19] << " " << cw[20] << " " << cw[21] << cw[22] << " " << cw[23] << endl;
	}
	return 0;
}
