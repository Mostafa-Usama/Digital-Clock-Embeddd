#include <mega16.h> 
#include <delay.h>
#include <alcd.h>
#include <stdlib.h>

#define KEY_PRT PORTB
#define KEY_DDR DDRB
#define KEY_PIN PINB

void clock();

void setclock();

void timer();

char keyfind();

void display(int h,int m,int s);

int hours();
int mintues(); 
int seconds();

unsigned char keypad[4][4] = { {'7','8','9','/'},
{'4','5','6','*'},
{'1','2','3','-'},
{' ','0','=','+'}};
int hour,mintue,second;
char x,y;
char time [2];
unsigned char colloc, rowloc,input;
void main(void)
{

 DDRC.0 = 1;  
 PORTC.0 = 0;
 DDRD.0 = 0;
 DDRD.3 = 0;
 PORTD.0 = 1;
 PORTD.3 = 1;
 
lcd_init(20);
while (1)
{


lcd_clear();
lcd_puts("1:Stopwatch");
lcd_gotoxy(0,1);
lcd_puts("2:Timer");
lcd_gotoxy(0,2);
lcd_puts("3:CLOCK");
input = keyfind();
lcd_putchar(input);
if(input == '1'){
       lcd_clear();
       hour = hours();
       delay_ms(1000); 
       lcd_clear(); 
       mintue = mintues();
       if(mintue>59){
       delay_ms(1000);
       lcd_clear();
       lcd_puts("Invalid input");
       delay_ms(1000);
       lcd_clear();
       }
       else {  
       delay_ms(1000);
       lcd_clear();
       second = seconds();
       delay_ms(1000);
          
       if (second < 60){
       lcd_clear(); 
       
       clock();
       lcd_clear();
        }
        else {
       lcd_clear();
       lcd_puts("Invalid input");
       delay_ms(1000);
       }      
       }     
}

if (input == '2')
{   lcd_clear();
    timer();
}

if (input == '3')
{   lcd_clear();
    setclock();
}
  
}

}
char keyfind()
{
while(1)
{
KEY_DDR = 0x0F; // set port direction as input-output
KEY_PRT = 0xF0;
do
{
delay_ms(20); /* 20ms key debounce time */
colloc = (KEY_PIN & 0xF0); /* read status of column */
}while(colloc == 0xF0); /* check for any key press */
delay_ms(100); /* 100ms key debounce time */
/* now check for rows */
KEY_PRT = 0xFE; // check for pressed key in 1st row
colloc = (KEY_PIN & 0xF0);
if(colloc != 0xF0)
{
rowloc = 0;
break;
}
KEY_PRT = 0xFD; // check for pressed key in 2nd row
colloc = (KEY_PIN & 0xF0);
if(colloc != 0xF0)
{
rowloc = 1;
break;
}
KEY_PRT = 0xFB; // check for pressed key in 3rd row
colloc = (KEY_PIN & 0xF0);
if(colloc != 0xF0)
{
rowloc = 2;
break;
}KEY_PRT = 0xF7; /* check for pressed key in 4th row */
colloc = (KEY_PIN & 0xF0);
if(colloc != 0xF0)
{
rowloc = 3;
break;
}
}
if(colloc == 0xE0)
return(keypad[rowloc][0]);
else if(colloc == 0xD0)
return(keypad[rowloc][1]);
else if(colloc == 0xB0)
return(keypad[rowloc][2]);
else
return(keypad[rowloc][3]);
}


int hours(){
            int hours;
lcd_puts("Enter hours: ");
   x = keyfind()-48;
   itoa(x,time);
   lcd_puts(time);
   y = keyfind()-48;
   itoa(y,time);
   lcd_puts(time);
   hours = x*10+y;
   return hours;
}

int mintues(){
       int mintues;
lcd_puts("Enter mintues: ");
   x = keyfind()-48;
   itoa(x,time);
   lcd_puts(time);
   y = keyfind()-48;
   itoa(y,time);
   lcd_puts(time);
   mintues = x*10+y;
     
  
   return mintues;
           
}

int seconds(){
       int seconds;
lcd_puts("Enter seconds: ");
   x = keyfind()-48;
   itoa(x,time);
   lcd_puts(time);
   y = keyfind()-48;
   itoa(y,time);
   lcd_puts(time);
   seconds = x*10+y;
   
   
   
   return seconds;
               
}
void display(int h, int m, int s){ 
    
       lcd_clear();       
       itoa(h,time);
       lcd_puts(time);
       lcd_puts(":");
       
       itoa(m,time);
       lcd_puts(time);
       lcd_puts(":"); 
       
       itoa(s,time);
       lcd_puts(time);
}

void clock(){
int i,j,k;
int check = 0;
int checkk = 0;   
for (i = hour; i >= 0; i--){
    if (checkk == 1){
    for(j = 59; j >= 0; j--){
        if(check == 1){
        
        
        for (k = 59; k >= 0; k--){
           
           display(i,j,k);
           delay_ms(1000);     
        }
        }
        else{
         check = 1;
        for (k = second; k >= 0; k--){ 
        if (PIND.0 == 0){
        return;
        }
         display(i,j,k);
         delay_ms(1000);  
        }
        } 
     } 
     } 
     else {
        checkk = 1;
     for(j = mintue; j >= 0; j--){
        if(check == 1){
        
        
        for (k = 59; k >= 0; k--){
           display(i,j,k);
           delay_ms(1000);     
        }
        }
        else{
         check = 1;
        for (k = second; k >= 0; k--){
        if (PIND.0 == 0){
        return;
        }
         display(i,j,k);
         delay_ms(1000);  
        }
        } 
     
     }           
     }
    

}
    lcd_gotoxy(0,1);
    lcd_puts("Time up!!");
       PORTC.0 = 1;
       delay_ms(2000);
       PORTC.0 = 0;
       lcd_clear();
 
}


void timer(){

int i,j,k;

for (i = 0; i <= 24; i++){
    
    for(j = 0; j < 60 ; j++){
      
        for (k = 0; k < 60; k++){
            if (PIND.0 == 0){
                lcd_clear();
                return;
            }  
            if (PIND.3 == 0){
                delay_ms(1300);
            
            while(1){
               if(PIND.3==0){ 
               delay_ms(100);
               break;  }     
               if (PIND.0 == 0){
                lcd_clear();
                return;
            } 
                
            }
             
              
            
            }
           display(i,j,k);
           delay_ms(1000);     
        }
    }
}
}

void setclock(){
int i,j,k,h,m,s;
    h=hours();
    delay_ms(1000);
    lcd_clear();
    m=mintues();
    delay_ms(1000);
    lcd_clear();
    s=seconds(); 
    delay_ms(1000);
    lcd_clear();
    if(h>23||m>59||s>59){
          lcd_puts("Invalid input");  
          delay_ms(2000);
    }
    for (i = h; i < 24; i++){
    
    for(j = m; j < 60 ; j++){
      
        for (k = s; k < 60; k++){
            
               if (PIND.0 == 0){
                lcd_clear();
                return;
            } 
               display(i,j,k);
               delay_ms(1000); 
            
            }
               
        }    
        
        if(i==23&&j==60&&k==60){   
        i=-1;j=0;k=0;
        h=-1;m=0;s=0;
        }
        
    }
}