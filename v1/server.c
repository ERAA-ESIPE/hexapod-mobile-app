#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <strings.h>

int main(int argc, char *argv[])
{

  if (argc != 3)
  {
    fprintf(stderr, "usage: %s <addr> <port>\n", argv[0]);
    exit(1);
  }

  int socket_desc, client_sock, c, read_size;
  struct sockaddr_in server, client;
  char client_message[2000];

  //Create socket
  socket_desc = socket(AF_INET, SOCK_STREAM, 0);
  if (socket_desc == -1)
  {
    printf("Could not create socket");
    exit(109);
  }

  //Prepare the sockaddr_in structure
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = inet_addr(argv[1]);
  server.sin_port = htons(atoi(argv[2]));

  //Bind
  if (bind(socket_desc, (struct sockaddr *)&server, sizeof(server)) < 0)
  {
    //print the error message
    perror("bind failed. Error");
    return 1;
  }

  //Listen
  listen(socket_desc, 3);

  //Accept and incoming connection
  c = sizeof(struct sockaddr_in);

  client_sock = accept(socket_desc, (struct sockaddr *)&client, (socklen_t *)&c);
  if (client_sock < 0)
  {
    perror("accept failed");
    return 1;
  }

  while ((read_size = recv(client_sock, client_message, 2000, 0)) > 0)
  {
    printf("%s", client_message);
    printf("\n");
    //write(client_sock, client_message, strlen(client_message));

    bzero(client_message, 2000 * sizeof(char));
  }

  if (read_size == 0)
  {
    puts("Client disconnected");
    fflush(stdout);
  }
  else if (read_size == -1)
  {
    perror("recv failed");
  }

  return 0;
}
