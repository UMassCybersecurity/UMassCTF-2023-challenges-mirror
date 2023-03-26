#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctype.h>
#include <time.h>

// gcc vuln.c -o vuln -fno-stack-protector

__attribute__((constructor)) void ignore_me() {
    setbuf(stdin, NULL);
    setbuf(stdout, NULL);
    setbuf(stderr, NULL);
}

#define SIZE 32

char *password;
struct Problem {
	char question[16];
	unsigned long long answer;
};

void print_main_menu() {
	puts("\n.~~~~~~~~~~~~.Menu.~~~~~~~~~~~~.");
	puts("\t~ 1 Launch Game ~");
	puts("\t~ 2 Edit config ~");
	puts("\t~ 3 Exit        ~");
	puts(".~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.");
	printf(" >> ");
}

void print_game_menu() {
	puts(".~~~~~~~~~~~~.Menu.~~~~~~~~~~~~.");
	puts("    ~ 1 Answer a question ~");
	puts("    ~ 2 Print Answers     ~");
	puts("    ~ 3 Start a new game  ~");
	puts("    ~ 4 End Game          ~");
	puts(".~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.");
	printf(" >> ");
}

int print_flag() {
	char flag[32] = {0};
	FILE *fd = fopen("flag.txt","r");

	if (fd == NULL) {
		puts("Something went wrong while opening the flag file.");
		exit(1);
	}
	fgets(flag, 0x30, fd);
	printf("The flag is: %s\n", flag);
	exit(1);
}

char *get_admin_pass() {
	char *buf = malloc(20);
	FILE *fp = fopen("/dev/urandom", "rb");
	fgets(buf, 16, fp);
	buf[16] = 0;
	fclose(fp);
	return buf;
}

void game() {
    unsigned int choice;
	char buf[0x8];
	char c;
	int count = 0;
	int score = 0;
	int ans;
	struct Problem problems[SIZE];

	srand(time(0));

	printf("Are you ready for the ultimate math game? [y/n]");
	printf("\n >> ");
	scanf("%c", &c);
	getchar();

	if (c == 'y') {
		for (int i = 0; i < SIZE; i++) {
			int v1 = rand() % 500;
			int v2 = rand() % 500;

			sprintf(problems[i].question, "%3d + %3d = ", v1, v2);
			problems[i].answer = v1 + v2;
		}
	} else if (c == 'n') {
		return;
	}

	while(1) {
		if (score == 20) {
			puts("Congrats, you managed to win the game");
			puts("You are officially this middle school's best mathlete");
			return;
		}
		print_game_menu();
		if (fgets(buf, sizeof(buf), stdin) == NULL) { exit(1); }
		choice = atoi(buf);
		
		switch(choice) {
			case 1:
				printf("Question %d: ", ++count);
				printf("%s\n", problems[count].question);
				if (fgets(buf, sizeof(buf), stdin) == NULL) { exit(1); }
				ans = atoi(buf);
				if (ans == problems[count].answer) { 
					puts("Good job, you got it right");
					score++; 
				} else {
					puts("Unfortunately that answer was incorrect");
				}
				break;
			case 2:
				for (int i = 0; i < SIZE; i++) {
					printf("%3d. %s", i, problems[i].question);
					printf("%lld\n", problems[i].answer);
				}
				return;
			case 3:
				puts("Restarting game...");
				game();
			case 4:
				puts("Exiting Game");
				return;
			default:
				printf("Unrecognized Option\n");
				break;
		}
	}
}

int authenticate_admin() {
	char user_pass[32];
	char padding1[500];
	char padding2[1020];
	char admin_pass[16];

	memcpy(admin_pass, password, 16);

	puts("Enter password");
	printf(" >> ");
	if (fgets(user_pass, 32, stdin) == NULL) { exit(1); }
	user_pass[strcspn(user_pass, "\n")] = 0;

	if (!strncmp(user_pass, admin_pass, 14)) {
		return 1;
	}
	return 0;
}

void config() {
	puts("Please authenticate to access the configs");
	if (authenticate_admin() == 0) {
		puts("Login failed");
		return;
	}
	puts("Login Successful, here are the creds");
	print_flag();
}

void run() {
	unsigned int choice;
	char buf[0x8];

	while(1) {
		print_main_menu();
		if (fgets(buf, sizeof(buf), stdin) == NULL) { exit(1); }
		choice = atoi(buf);
		
		switch(choice) {
			case 1:
				game();
				break;
			case 2:
				config();
				break;
			case 3:
				printf("Shutting Off...\n");
				exit(1);
				break;
			default:
				printf("Unrecognized Option\n");
				break;
		}
	}
}

int main() {
	password = get_admin_pass();
	run();
	return 1;
}
