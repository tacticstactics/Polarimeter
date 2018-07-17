

function [Ea] = jones_propagate_func(wavel1,no,octwp,in)


%phase      
 P1 = exp((-1j*2*pi*no * octwp)/ wavel1);              

        
 Ea = P1 * in ;
 
end