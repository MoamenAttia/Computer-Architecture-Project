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
#include <unordered_map>

using namespace std;
map<string, string>TwoOp, OneOp, General_Purpose_Register,NoOp,Branch,Bonus;
map<string, int>Variables;
map<char, string>Addressing_Mode;
string Command, Instruction, IR = "", Op1, Op2,offset,BIN;
vector<string>Code,Output; vector<int>Address;
int Insturction_Iterator; bool Assign;
void init()
{
	TwoOp["MOV"] = "0000";
	TwoOp["ADD"] = "0001";
	TwoOp["ADC"] = "0010";
	TwoOp["SUB"] = "0011";
	TwoOp["SBC"] = "0100";
	TwoOp["AND"] = "0101";
	TwoOp["OR"] = "0110";
	TwoOp["XNOR"] = "0111";
	TwoOp["CMP"] = "1000";

	OneOp["INC"] = "0000";
	OneOp["DEC"] = "0001";
	OneOp["CLR"] = "0010";
	OneOp["INV"] = "0011";
	OneOp["LSR"] = "0100";
	OneOp["ROR"] = "0101";
	OneOp["RRC"] = "0110";
	OneOp["ASR"] = "0111";
	OneOp["LSL"] = "1000";
	OneOp["ROL"] = "1001";
	OneOp["RLC"] = "1010";

	NoOp["HLT"] = "0";
	NoOp["NOP"] = "1";

	Branch["BR"]  = "000";
	Branch["BEQ"] = "001";
	Branch["BNE"] = "010";
	Branch["BLO"] = "011";
	Branch["BLS"] = "100";
	Branch["BHI"] = "101";
	Branch["BHS"] = "110";

	Addressing_Mode['R'] = "00";
	Addressing_Mode['('] = "01";
	Addressing_Mode['-'] = "10";
	Addressing_Mode['x'] = "11";

	General_Purpose_Register["R0"] = "000";
	General_Purpose_Register["R1"] = "001";
	General_Purpose_Register["R2"] = "010";
	General_Purpose_Register["R3"] = "011";
	General_Purpose_Register["R4"] = "100";
	General_Purpose_Register["R5"] = "101";
	General_Purpose_Register["R6"] = "110";
	General_Purpose_Register["R7"] = "111";

}
// The following function make all the letters of the command in Capital letters and make spaces between letters.
void Adjust_command(string& s)
{
	if (s.find(';') != -1) 
		s.erase(s.find(';'));
	
	for (int i = 0; i<s.size(); ++i)
	{
		if (isalpha(s[i])) s[i] = toupper(s[i]);
		if (s[i] == ',') s[i] = ' ';
	}
}
string Get_Register(string op)
{
	string ret = "";
	for (int i = find(op.begin(),op.end(),'(') - op.begin(); i<op.size(); ++i)
		if (isdigit(op[i])) {
			ret += "R";
			ret += op[i];
			return ret;
		}
}
string To_Binary(int x)
{
	string ret = "";
	if (!x) return "0";
	while (x) ret += ('0' + x % 2), x >>= 1;
	reverse(ret.begin(), ret.end());
	return ret;
}
void Fetch_Operand(string& op,int address=0)
{
	if (op[0] == '@') op.erase(0,1), IR += '1';
	else IR += '0';

	char F = op[0]; //First Letter.
	
	string Register;
	if (F == 'R') // register direct addressing mode
	{
		if (!Assign) return;
		Register = op;
	}
	else if (F == '(') // auto increment adressing mode 
	{
		if (!Assign) return;
		Register = Get_Register(op);
	}
	else if (F == '-' && op[1]=='(') // auto decrement addressing mode
	{	
		if (!Assign) return;
		Register = Get_Register(op);
	}
	else if (F == '-' || isdigit(F))  // indexed addressing mode with x.
	{
		// ATTENTIONNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN negative conversion to binary should be handled
		
		Insturction_Iterator++;
		if (!Assign) return;
		stringstream x( op.substr(0,find(op.begin(),op.end(),'(') - op.begin()) );
		int offset;
		x >> offset;
		Register = Get_Register(op);
		F = 'x';
	
		BIN = To_Binary(abs(offset));
		BIN = (offset>=0? '0':'1') + BIN;
	}
	else if (F == '#')
	{
		Insturction_Iterator++;
		if (!Assign) return;
		op.erase(0, 1);
		stringstream ss(op);
		int number; ss >> number;
		BIN = To_Binary(number);
		F = '('; Register = "R7";
	}
	else {
		Insturction_Iterator++;
		if (!Assign) return;
		int offset = (Variables[op] - address - 1);
		Register = "R7";
		F = 'x';
		BIN = To_Binary(offset);
	}
	if (!Assign) return;
	IR += Addressing_Mode[F];
	IR += ' ';
	IR += General_Purpose_Register[Register];
	IR += ' ';
}
void Get_IR(string Command, int address = 0)
{
	stringstream ss;
	ss << Command;
	ss >> Instruction;
	if (TwoOp.count(Instruction))
	{
		if (Assign) {
			IR += TwoOp[Instruction];
			IR += ' ';
		}
		ss >> Op1, ss >> Op2;
		Fetch_Operand(Op1,address);
		Fetch_Operand(Op2,address);
	}
	else if (OneOp.count(Instruction))
	{
		if (Assign) {
			IR += "1001";
			IR += OneOp[Instruction];
			ss >> Op1;
			IR += "xx";
		}
		Fetch_Operand(Op1,address);

	}
	else if (NoOp.count(Instruction))
	{
		if (Assign) {
			IR += "1010";
			IR += OneOp[Instruction];
			IR += "xxxxxxxxxxx";
		}
	}
	else if (Branch.count(Instruction))
	{
		if (Assign) {
			IR += "11";
			IR += Branch[Instruction];
			string Label_Name;
			ss >> Label_Name;
			int difference = Variables[Label_Name] - address - 1;
			string offset = To_Binary(abs(difference));

			IR += (difference >= 0 ? '0' : '1');
			while (offset.size() < 10) offset = '0' + offset;
			IR += offset;
		}
	}
	else if(Instruction == "DEFINE")
	{
		if (!Assign) {
			ss >> Op1;
			Variables[Op1] = Insturction_Iterator;
		}
	}
	else if (Instruction[0] ==';') // for the comments
	{
		if (!Assign) {
			Insturction_Iterator--; 
			
		}
	}
	else {
		if (!Assign) {
			Instruction.erase(find(Instruction.begin(), Instruction.end(), ':'));
			Variables[Instruction] = Insturction_Iterator;
			Insturction_Iterator--; // Label, the iterator should stay the same.

		}
	}
}
int main()
{		
	init();

	freopen("input.txt", "r", stdin);
	freopen("output.txt", "w", stdout);
	Assign = false;
	int debugger = 0;
	while(getline(cin, Command))
	{
		Adjust_command(Command);
		if (Command.empty()) continue;

		Code.push_back(Command);
		Address.push_back(Insturction_Iterator);
		Get_IR(Command);  // Note : Assign is false, so this function is only calculate Instructor Iterator.
		Insturction_Iterator++;
	}
	Assign = true;
	for (int idx = 0; idx < Code.size();idx++) 
	{
		stringstream ss;
		IR.clear();
		Get_IR(Code[idx],Address[idx]);
		if(!IR.empty()) Output.push_back(IR);
		if (!BIN.empty()) Output.push_back(BIN);
		BIN.clear();
	}
	for (auto out : Output) 
		cout << out << endl;
	return 0;
}
