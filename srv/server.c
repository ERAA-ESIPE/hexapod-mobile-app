#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <strings.h>


char** str_split(char* a_str, const char a_delim)
{
    char** result    = 0;
    size_t count     = 0;
    char* tmp        = a_str;
    char* last_comma = 0;
    char delim[2];
    delim[0] = a_delim;
    delim[1] = 0;

    /* Count how many elements will be extracted. */
    while (*tmp)
    {
        if (a_delim == *tmp)
        {
            count++;
            last_comma = tmp;
        }
        tmp++;
    }

    /* Add space for trailing token. */
    count += last_comma < (a_str + strlen(a_str) - 1);

    /* Add space for terminating null string so caller
       knows where the list of returned strings ends. */
    count++;

    result = malloc(sizeof(char*) * count);

    if (result)
    {
        size_t idx  = 0;
        char* token = strtok(a_str, delim);

        while (token)
        {
            *(result + idx++) = strdup(token);
            token = strtok(0, delim);
        }
        *(result + idx) = 0;
    }

    return result;
}

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

    char** tokens = str_split(client_message, ';');
    if (tokens)
    {
        printf("-------------------------- \n");
        int i;
        for (i = 0; *(tokens + i); i++)
        {
            int number = (int)strtol(*(tokens + i), NULL, 16);
            printf("toInt: %d\n", number);
            free(*(tokens + i));
        }
        printf("-------------------------- \n");
        free(tokens);
    }
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
