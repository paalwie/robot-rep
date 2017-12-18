function zeichne_ks2(P,L)

% unterschiedliche Länge der Achsvektoren
%[error] = ks(Frame,Length)
%
%plot the koordinate system described by frame P
%red = x
%green = y
%blue = z
%
%
%Parameter:
%
%P          [4 x 4] frame
%
%L          length of koordinate system axis 
%
%Return Values:
%
%error      always -1
%

%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   stark@informatik.fh-augsburg.de             *
%   Labor CIM & Robotik                         *
%   2006                                        *
%************************************************


B = P(1:3,1:3) .* L;
B(1:3,1) = P(1:3,1) .* 2*L/3;
B(1:3,2) = P(1:3,2) .* L/3;
O = [P(1:3,4)'; P(1:3,4)'; P(1:3,4)']';
B = B + O;
hold on
plot3([P(1,4) B(1,1)],[P(2,4) B(2,1)],[P(3,4) B(3,1)],'Color','r','LineWidth',3);
%line([P(1,4) B(1,1)],[P(2,4) B(2,1)],[P(3,4) B(3,1)],'Color','r','LineWidth',3);
plot3([P(1,4) B(1,2)],[P(2,4) B(2,2)],[P(3,4) B(3,2)],'Color','g','LineWidth',3);
plot3([P(1,4) B(1,3)],[P(2,4) B(2,3)],[P(3,4) B(3,3)],'Color','b','LineWidth',3);

